unit ConsVars;

interface
uses Windows, Messages, SysUtils, Classes, Contnrs, Graphics, DTLangTools;

type
   // Exception
  ETranEdError = class(Exception);

   //===================================================================================================================
   // A single property language source
   //===================================================================================================================

  PPropertySource = ^TPropertySource;
  TPropertySource = record
    iID:       Integer; // Owner-wide unique property ID
    sPropName: String;  // Property name (fullly qualified)
    sValue:    String;  // Original property value
  end;

   //===================================================================================================================
   // List of TPropertySource. Entries are sorted by ID
   //===================================================================================================================

  TPropertySources = class(TList)
  private
    function GetItems(Index: Integer): PPropertySource;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function  Add(iID: Integer; const sPropName, sValue: String): Integer;
     // Tries to find the entry by property ID; returns True, if succeeded, and its index in iIndex; otherwise returns
     //   False and its adviced insertion-point index in iIndex
    function  FindID(iID: Integer; out iIndex: Integer): Boolean;
     // Returns the entry by given ID, or nil if not found
    function  FindPropByID(iID: Integer): PPropertySource;
     // Returns the index of entry by given ID, or -1 if not found
    function  IndexOfID(iID: Integer): Integer;
     // Returns the index of entry by given property name, or -1 if not found
    function  IndexOfPropName(const sPropName: String): Integer;
     // Props
     // -- Items by index
    property Items[Index: Integer]: PPropertySource read GetItems; default;
  end;

   //===================================================================================================================
   // Language source for a whole component hierarchy (represented as a section in language source file)
   //===================================================================================================================

  PComponentSource = ^TComponentSource;
  TComponentSource = class(TObject)
  private
     // Prop storage
    FPropertySources: TPropertySources;
    FCompName: String;
  public
    constructor Create(const sCompName: String);
    destructor Destroy; override;
     // Props
     // -- Associated component (section) name
    property CompName: String read FCompName;
     // -- Owned property entries
    property PropertySources: TPropertySources read FPropertySources;
  end;

   //===================================================================================================================
   // List of TComponentSource. Entries are sorted by component name
   //===================================================================================================================

  TComponentSources = class(TObjectList)
  private
    function GetItems(Index: Integer): TComponentSource;
  public
    function  Add(Item: TComponentSource): Integer;
     // Tries to find the component by name; returns True, if succeeded, and its index in iIndex; otherwise returns
     //   False and its adviced insertion-point index in iIndex
    function  FindCompName(const sCompName: String; out iIndex: Integer): Boolean;
     // Returns the entry by given component name, or nil if not found
    function  FindCompByName(const sCompName: String): TComponentSource;
     // Returns the index of entry by given component name, or -1 if not found
    function  IndexOfCompName(const sCompName: String): Integer;
     // Props
     // -- Items by index
    property Items[Index: Integer]: TComponentSource read GetItems; default;
  end;

   //===================================================================================================================
   // Language source storage (allows read-only access to language source files)
   //===================================================================================================================

  TLangSource = class(TObject)
  private
     // Prop storage
    FFileName: String;
    FComponentSources: TComponentSources;
    FConstants: TDKLang_Constants;
     // Parses the Strings containing language source
    procedure LoadFromStrings(Strings: TStrings);
  public
     // Loads the specified language source file and updates FileName property
    constructor Create(const sFileName: String);
    destructor Destroy; override;
     // Compares the component, property  and constant presence with Translations, updates Translations by removing the
     //   excessive entries and adding missing ones and returns the textual description of what has been changed in
     //   Translations, or an empty string if no differences in structure found
    function  CompareStructureWith(Translations: TDKLang_CompTranslations): String;
     // Props
     // -- Owned component sources
    property ComponentSources: TComponentSources read FComponentSources;  
     // -- Constant entries
    property Constants: TDKLang_Constants read FConstants;
     // -- The language source file open
    property FileName: String read FFileName;
  end;


const
  S_CRLF                           = #13#10;

  SAppCaption                      = 'DKLang Translation Editor';
  SAppVersion                      = '1.01';

  SLangSourceFileExt               = 'dklang';
  SLangSourceFileFilter            = 'DKLang language source files (*.dklang)|*.dklang|All Files (*.*)|*.*';
  STranFileExt                     = 'lng';
  STranFileFilter                  = 'DKLang translation files (*.lng)|*.lng|All Files (*.*)|*.*';
  STranFileDefaultName             = 'untitled.'+STranFileExt;


  SDTLSFileFilter                  = 'DaleTech Language Snapshots (*.dtls;*.xdtls)|*.dtls;*.xdtls|All Files (*.*)|*.*';

   // Dialog titles
  SDlgTitle_Info                   = 'Info';
  SDlgTitle_Error                  = 'Error';
  SDlgTitle_Confirm                = 'Confirm';
  SDlgTitle_SelectLangSourceFile   = 'Select a language source file';
  SDlgTitle_SelectTranFile         = 'Select a translation file';
  SDlgTitle_SaveTranFileAs         = 'Select a translation file to save to';

   // Dialog texts
  SConfirm_FileNotSaved            = 'Translation file "%s" is modified but not saved. Do you wish to save it?';

   // Error messages
  SErrMsg_FileDoesntExist          = 'File "%s" doesn''t exist';
  SErrMsg_DuplicatePropID          = 'Duplicate property ID: %d';
  SErrMsg_DuplicatePropName        = 'Duplicate property name: "%s"';
  SErrMsg_DuplicateCompName        = 'Duplicate component name: "%s"';
  SErrMsg_InvalidCompName          = 'Invalid component name: "%s"';
  SErrMsg_CharMissing              = '"%s" missing';
  SErrMsg_WrongSectionName         = 'Wrong section name format: "%s"';
  SErrMsg_SectionNameMissing       = 'Section name missing';
  SErrMsg_SectionlessEntry         = 'Sectionless entries are not allowed';
  SErrMsg_ConstNameMissing         = 'Constant name missing';
  SErrMsg_PropNameMissing          = 'Property name missing';
  SErrMsg_PropIDMissing            = 'Property ID missing';
  SErrMsg_PropIDInvalid            = 'Invalid property ID';
  SErrMsg_LoadLangSourceFailed     = 'Error loading language source:'#13'Line %d: %s';

  SNode_Constants                  = 'Constants';

   // Source/translation difference messages
  SDiffDesc_AddComponent           = '+ Component: [%s]';
  SDiffDesc_AddProperty            = '+ Property "%s" (ID=%d)';
  SDiffDesc_AddConstant            = '+ Constant "%s"';
  SDiffDesc_RemoveComponent        = '- Component: [%s]';
  SDiffDesc_RemoveProperty         = '- Component "%s", property with ID=%d';
  SDiffDesc_RemoveConstant         = '- Constant "%s"';
  SDiffDesc_MissingEntries         = 'The following entries were not found and were added to the translation:';
  SDiffDesc_ExcessiveEntries       = 'The following entries were found excessive and deleted from the translation:';



  SOpenDlgTitle                    = 'Select language snapshot file to open';
  SDlgSelReposPath                 = 'Select translation repository path:';
  SDlgAddConstant                  = 'Add a constant';
  SDlgRenameConstant               = 'Rename the constant';

  SDeleteLangMsg                   = 'Are you sure you want to delete current language?';
  SDlgConstantPropsLabel           = '&Constant name:';
  SDeleteConstConfirm              = 'Are you sure you want to delete the constant?';
  SDuplicateConstant               = 'Duplicate constant names are not allowed';

  SReplaceLangLabel                = '&Replace current language with:';
                                   
   // Пути реестра                 
  SRegKey_Root                     = 'Software\DKSoftware\DKTranEd';
  SRegKey_Toolbars                 = SRegKey_Root+'\Toolbars';
  SRegSection_MainWindow           = 'MainWindow';
//  SRegSection_OpenMRU              = 'OpenMRU';
  SRegSection_Preferences          = 'Preferences';

   // Имя файла репозитория
  STranRepositoryFileName          = 'dt_repos.dat';

   // Main tree column indexes
  IColIdx_Name                     = 0;
  IColIdx_ID                       = 1;
  IColIdx_Original                 = 2;
  IColIdx_Translated               = 3;

   // ImageIndices                 
  iiSettings                       =  0;
  iiFolder                         =  1;
  iiNew                            =  2;
  iiOpen                           =  3;
  iiSave                           =  4;
  iiSaveAs                         =  5;
  iiExit                           =  6;
  iiAbout                          =  7;
  iiLanguage                       =  8;
  iiAddLang                        =  9;
  iiDelLang                        = 10;
  iiReplaceLang                    = 11;
  iiNode_Comp                      = 12;
  iiNode_Consts                    = 13;
  iiNode_Prop                      = 14;
  iiNode_Const                     = 15;
  iiAddConst                       = 16;
  iiDelConst                       = 17;
  iiReplaceConst                   = 18;

var
  sTranRepositoryPath:  String;     // Путь к репозиторию
  bReposRemovePrefix:   Boolean;    // Удалять '&' из переводов
  bReposAutoAddStrings: Boolean;    // Автоматически добавлять строки к переводам

   // Exception raising
  procedure TranEdError(const sMsg: String); overload;
  procedure TranEdError(const sMsg: String; const aParams: Array of const); overload;

  function  iif(b: Boolean; const sTrue, sFalse: String): String;     overload;
  function  iif(b: Boolean; iTrue, iFalse: Integer): Integer;         overload;
  function  iif(b: Boolean; const iTrue, iFalse: Int64): Int64;       overload;
  function  iif(b: Boolean; const dTrue, dFalse: Double): Double;     overload;
  function  iif(b: Boolean; const xTrue, xFalse: Extended): Extended; overload;
  function  iif(b: Boolean; pTrue, pFalse: Pointer): Pointer;         overload;

  procedure Info(const sMessage: String);
  procedure Error(const sMessage: String);
  function  Confirm(const sMessage: String): Boolean;

   // Проверяет существование файла. Если он не существует, вызывает Exception
  procedure CheckFileExists(const sFileName: String);

implementation
uses Forms;

  procedure TranEdError(const sMsg: String);
  begin
    raise ETranEdError.Create(sMsg);
  end;

  procedure TranEdError(const sMsg: String; const aParams: Array of const); overload;
  begin
    raise ETranEdError.CreateFmt(sMsg, aParams);
  end;

  function iif(b: Boolean; const sTrue, sFalse: String): String;
  begin
    if b then Result := sTrue else Result := sFalse;
  end;

  function iif(b: Boolean; iTrue, iFalse: Integer): Integer;
  begin
    if b then Result := iTrue else Result := iFalse;
  end;

  function iif(b: Boolean; const iTrue, iFalse: Int64): Int64;
  begin
    if b then Result := iTrue else Result := iFalse;
  end;

  function iif(b: Boolean; const dTrue, dFalse: Double): Double;
  begin
    if b then Result := dTrue else Result := dFalse;
  end;

  function iif(b: Boolean; const xTrue, xFalse: Extended): Extended;
  begin
    if b then Result := xTrue else Result := xFalse;
  end;

  function iif(b: Boolean; pTrue, pFalse: Pointer): Pointer;
  begin
    if b then Result := pTrue else Result := pFalse;
  end;

  procedure Info(const sMessage: String);
  begin
    Application.MessageBox(PChar(sMessage), PChar(SDlgTitle_Info), MB_OK or MB_ICONINFORMATION);
  end;

  procedure Error(const sMessage: String);
  begin
    Application.MessageBox(PChar(sMessage), PChar(SDlgTitle_Error), MB_OK or MB_ICONERROR);
  end;

  function Confirm(const sMessage: String): Boolean;
  begin
    Result := Application.MessageBox(PChar(sMessage), PChar(SDlgTitle_Confirm), MB_OKCANCEL or MB_ICONQUESTION)=IDOK;
  end;

  procedure CheckFileExists(const sFileName: String);
  begin
    if not FileExists(sFileName) then raise Exception.CreateFmt(SErrMsg_FileDoesntExist, [sFileName]);
  end;

   //===================================================================================================================
   // TPropertySources
   //===================================================================================================================

  function TPropertySources.Add(iID: Integer; const sPropName, sValue: String): Integer;
  var p: PPropertySource;
  begin
     // Check ID uniqueness and find insertion point
    if FindID(iID, Result) then TranEdError(SErrMsg_DuplicatePropID, [iID]);
     // Check name uniqueness
    if IndexOfPropName(sPropName)>=0 then TranEdError(SErrMsg_DuplicatePropName, [sPropName]);
     // Create the entry
    New(p);
    Insert(Result, p);
    p.iID       := iID;
    p.sPropName := sPropName;
    p.sValue    := sValue;
  end;

  function TPropertySources.FindID(iID: Integer; out iIndex: Integer): Boolean;
  var iL, iR, i, iItemID: Integer;
  begin
     // Since the list is sorted by ID, implement binary search here
    Result := False;
    iL := 0;
    iR := Count-1;
    while iL<=iR do begin
      i := (iL+iR) shr 1;
      iItemID := GetItems(i).iID;
      if iItemID<iID then
        iL := i+1
      else if iItemID=iID then begin
        Result := True;
        iL := i;
        Break;
      end else
        iR := i-1;
    end;
    iIndex := iL;
  end;

  function TPropertySources.FindPropByID(iID: Integer): PPropertySource;
  var idx: Integer;
  begin
    if FindID(iID, idx) then Result := GetItems(idx) else Result := nil;
  end;

  function TPropertySources.GetItems(Index: Integer): PPropertySource;
  begin
    Result := Get(Index);
  end;

  function TPropertySources.IndexOfID(iID: Integer): Integer;
  begin
    if not FindID(iID, Result) then Result := -1;
  end;

  function TPropertySources.IndexOfPropName(const sPropName: String): Integer;
  begin
    for Result := 0 to Count-1 do
      if AnsiSameText(GetItems(Result).sPropName, sPropName) then Exit;
    Result := -1;
  end;

  procedure TPropertySources.Notify(Ptr: Pointer; Action: TListNotification);
  begin
    if Action=lnDeleted then Dispose(PPropertySource(Ptr));
  end;

   //===================================================================================================================
   // TComponentSource
   //===================================================================================================================

  constructor TComponentSource.Create(const sCompName: String);
  begin
    inherited Create;
     // Check name format
    if not IsValidIdent(sCompName) then TranEdError(SErrMsg_InvalidCompName, [sCompName]);
    FPropertySources := TPropertySources.Create;
    FCompName        := sCompName;
  end;

  destructor TComponentSource.Destroy;
  begin
    FPropertySources.Free;
    inherited Destroy;
  end;

   //===================================================================================================================
   // TComponentSources
   //===================================================================================================================

  function TComponentSources.Add(Item: TComponentSource): Integer;
  begin
     // Check name uniqueness and find insertion point
    if FindCompName(Item.CompName, Result) then TranEdError(SErrMsg_DuplicateCompName, [Item.CompName]);
    Insert(Result, Item);
  end;

  function TComponentSources.FindCompByName(const sCompName: String): TComponentSource;
  var idx: Integer;
  begin
    if FindCompName(sCompName, idx) then Result := GetItems(idx) else Result := nil;
  end;

  function TComponentSources.FindCompName(const sCompName: String; out iIndex: Integer): Boolean;
  var iL, iR, i: Integer;
  begin
     // Since the list is sorted by component name, implement binary search here
    Result := False;
    iL := 0;
    iR := Count-1;
    while iL<=iR do begin
      i := (iL+iR) shr 1;
       // Don't use AnsiCompareText() here as component names are allowed to consist of alphanumeric chars and '_' only
      case CompareText(GetItems(i).CompName, sCompName) of
        Low(Integer)..-1: iL := i+1;
        0: begin
          Result := True;
          iL := i;
          Break;
        end;
        else iR := i-1;
      end;
    end;
    iIndex := iL;
  end;

  function TComponentSources.GetItems(Index: Integer): TComponentSource;
  begin
    Result := TComponentSource(Get(Index));
  end;

  function TComponentSources.IndexOfCompName(const sCompName: String): Integer;
  begin
    if not FindCompName(sCompName, Result) then Result := -1;
  end;

   //===================================================================================================================
   // TLangSource
   //===================================================================================================================

  function TLangSource.CompareStructureWith(Translations: TDKLang_CompTranslations): String;
  var sText: String;

    procedure AddLine(const s: String; const aParams: Array of const);
    begin
      sText := sText+Format(s, aParams)+S_CRLF;
    end;

    procedure CheckMissingComps;
    var
      iComp, iProp: Integer;
      SrcComp: TComponentSource;
      TranComp: TDKLang_CompTranslation;
      pSrcProp: PPropertySource;
      pTranProp: PDKLang_PropValueTranslation;
      bCompCreated: Boolean;
    begin
       // Iterate through component entries
      for iComp := 0 to FComponentSources.Count-1 do begin
        SrcComp := FComponentSources[iComp];
         // Try to find the component in translation
        TranComp := Translations.FindComponentName(SrcComp.CompName);
         // If not found
        if TranComp=nil then begin
           // Add the component to Translations
          TranComp := TDKLang_CompTranslation.Create(SrcComp.CompName);
          Translations.Add(TranComp);
           // Log the difference
          AddLine(SDiffDesc_AddComponent, [SrcComp.CompName]);
          bCompCreated := True;
        end else
          bCompCreated := False;
         // Check the component's properties
        for iProp := 0 to SrcComp.PropertySources.Count-1 do begin
          pSrcProp := SrcComp.PropertySources[iProp];
           // If component was created, all props will be missing. Otherwise try to find the prop
          if bCompCreated then pTranProp := nil else pTranProp := TranComp.FindPropByID(pSrcProp.iID);
           // If not found
          if pTranProp=nil then begin
             // Add the property to Translations
            TranComp.Add(pSrcProp.iID, pSrcProp.sValue);
             // Log the difference
            AddLine('    '+SDiffDesc_AddProperty, [pSrcProp.sPropName, pSrcProp.iID]);
          end;
        end;
      end;
    end;

    procedure CheckMissingConsts;
    var
      iConst: Integer;
      pSrcConst, pTranConst: PDKLang_Constant;
    begin
       // Iterate through the constant entries
      for iConst := 0 to FConstants.Count-1 do begin
        pSrcConst := FConstants[iConst];
         // Try to find the constant in translation
        pTranConst := Translations.Constants.FindConstName(pSrcConst.sName);
         // If not found
        if pTranConst=nil then begin
           // Add the constant to Translations
          Translations.Constants.Add(pSrcConst.sName, pSrcConst.sDefValue);
           // Log the difference
          AddLine(SDiffDesc_AddConstant, [pSrcConst.sName]);
        end;
      end;
    end;

    procedure CheckExcessiveComps;
    var
      iComp, iProp: Integer;
      SrcComp: TComponentSource;
      TranComp: TDKLang_CompTranslation;
      pTranProp: PDKLang_PropValueTranslation;
    begin
       // Iterate through the translated component entries
      iComp := 0;
      while iComp<Translations.Count do begin
        TranComp := Translations[iComp];
         // Try to find the component in source
        SrcComp := FComponentSources.FindCompByName(TranComp.ComponentName);
         // If not found
        if SrcComp=nil then begin
           // Log the difference
          AddLine(SDiffDesc_RemoveComponent, [TranComp.ComponentName]);
           // Remove the component from Translations
          Translations.Remove(TranComp);
        end else begin
           // Check the component's properties
          iProp := 0;
          while iProp<TranComp.Count do begin
            pTranProp := TranComp[iProp];
             // If prop in source not found
            if SrcComp.PropertySources.IndexOfID(pTranProp.iID)<0 then begin
               // Log the difference
              AddLine(SDiffDesc_RemoveProperty, [TranComp.ComponentName, pTranProp.iID]);
               // Remove the property from Translations
              TranComp.Remove(pTranProp);
            end else
              Inc(iProp);
          end;
          Inc(iComp);
        end;
      end;
    end;

    procedure CheckExcessiveConsts;
    var
      iConst: Integer;
      pTranConst: PDKLang_Constant;
    begin
       // Iterate through the constant entries
      iConst := 0;
      while iConst<Translations.Constants.Count do begin
        pTranConst := Translations.Constants[iConst];
         // If source constant not found
        if FConstants.IndexOfName(pTranConst.sName)<0 then begin
           // Log the difference
          AddLine(SDiffDesc_RemoveConstant, [pTranConst.sName]);
           // Remove the constant from Translations
          Translations.Constants.Remove(pTranConst);
        end else
          Inc(iConst);
      end;
    end;

  begin
    Result := '';
     // Check missing entries
    sText := '';
    CheckMissingComps;
    CheckMissingConsts;
    if sText<>'' then Result := Result+SDiffDesc_MissingEntries+S_CRLF+sText+S_CRLF;
     // Check excessive entries
    sText := '';
    CheckExcessiveComps;
    CheckExcessiveConsts;
    if sText<>'' then Result := Result+SDiffDesc_ExcessiveEntries+S_CRLF+sText+S_CRLF;
  end;

  constructor TLangSource.Create(const sFileName: String);
  var Strings: TStrings;
  begin
    inherited Create;
    FComponentSources := TComponentSources.Create;
    FConstants        := TDKLang_Constants.Create;
    FFileName := sFileName;
     // Create temporary strings object and load the source from it
    Strings := TStringList.Create;
    try
      Strings.LoadFromFile(sFileName);
      LoadFromStrings(Strings);
    finally
      Strings.Free;
    end;
  end;

  destructor TLangSource.Destroy;
  begin
    FConstants.Free;
    FComponentSources.Free;
    inherited Destroy;
  end;

  procedure TLangSource.LoadFromStrings(Strings: TStrings);
  var
    iLine: Integer;
    sLine: String;
    Comp: TComponentSource;
    bConstantSection: Boolean;

    procedure ParseSection;
    var
      iBracket: Integer;
      sSectionName: String;
    begin
       // Check ']' position
      iBracket := Pos(']', sLine);
      if iBracket=0 then TranEdError(SErrMsg_CharMissing, [']']);
      if iBracket<>Length(sLine) then TranEdError(SErrMsg_WrongSectionName, [sLine]);
       // Extract section name
      sSectionName := Trim(Copy(sLine, 2, Length(sLine)-2));
      if sSectionName='' then TranEdError(SErrMsg_SectionNameMissing);
       // Check if this is constant section
      if SameText(sSectionName, SDKLang_ConstSectionName) then
        bConstantSection := True
       // Else create a new component entry
      else begin
        bConstantSection := False;
        Comp := TComponentSource.Create(sSectionName);
        try
          FComponentSources.Add(Comp);
        except
          Comp.Free;
          raise;
        end;
      end;
    end;

    procedure ParseConstant;
    var
      iEq: Integer;
      sConstName: String;
    begin
       // Check '='
      iEq := Pos('=', sLine);
      if iEq=0 then TranEdError(SErrMsg_CharMissing, ['=']);
       // Parse constant name
      sConstName := Trim(Copy(sLine, 1, iEq-1));
      if sConstName='' then TranEdError(SErrMsg_ConstNameMissing);
       // Extract constant value and add the constant to the list
      FConstants.Add(sConstName, Trim(Copy(sLine, iEq+1, MaxInt)));
    end;

    procedure ParseProperty;
    var
      iEq, iComma, iID: Integer;
      sPropName, sIDVal: String;
    begin
       // Check whether there was a section before
      if Comp=nil then TranEdError(SErrMsg_SectionlessEntry);
       // Check '='
      iEq := Pos('=', sLine);
      if iEq=0 then TranEdError(SErrMsg_CharMissing, ['=']);
       // Parse property name
      sPropName := Trim(Copy(sLine, 1, iEq-1));
      if sPropName='' then TranEdError(SErrMsg_PropNameMissing);
       // Extract ID & value
      sIDVal := Trim(Copy(sLine, iEq+1, MaxInt));
       // Parse ID
      iComma := Pos(',', sIDVal);
      if (sIDVal='') or (iComma=1) then TranEdError(SErrMsg_PropIDMissing);
      if iComma=0 then TranEdError(SErrMsg_CharMissing, [',']);
      iID := StrToIntDef(Copy(sIDVal, 1, iComma-1), 0);
      if iID<=0 then TranEdError(SErrMsg_PropIDInvalid);
       // Extract value and add the property
      Comp.PropertySources.Add(iID, sPropName, Trim(Copy(sIDVal, iComma+1, MaxInt)));
    end;

  begin
    bConstantSection := False;
     // Iterate through the lines
    for iLine := 0 to Strings.Count-1 do begin
      sLine := Trim(Strings[iLine]);
      try
         // Skip empty lines or comments
        if (sLine<>'') and (sLine[1]<>';') then
          case sLine[1] of
             // A section?
            '[': ParseSection;
             // Property/constant line?
            else if bConstantSection then ParseConstant else ParseProperty;
          end;
      except
        on e: ETranEdError do TranEdError(SErrMsg_LoadLangSourceFailed, [iLine+1, e.Message]);
      end;
    end;
  end;

end.
