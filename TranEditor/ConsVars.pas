//**********************************************************************************************************************
//  $Id: ConsVars.pas,v 1.13 2004-10-13 11:00:45 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit ConsVars;

interface
uses Windows, Messages, SysUtils, Classes, Contnrs, Controls, Graphics, StdCtrls, VirtualTrees, DKLang, dkWebUtils;

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
    function  CompareStructureWith(Translations: TDKLang_CompTranslations; out iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer): String;
     // Props
     // -- Owned component sources
    property ComponentSources: TComponentSources read FComponentSources;  
     // -- Constant entries
    property Constants: TDKLang_Constants read FConstants;
     // -- The language source file open
    property FileName: String read FFileName;
  end;

   //===================================================================================================================
   // Translation entry list
   //===================================================================================================================

   // A translation repository entry
  PTranRepositoryEntry = ^TTranRepositoryEntry;
  TTranRepositoryEntry = record
    wLangID1: LANGID; // Source language ID
    sValue1:  String; // Source value
    wLangID2: LANGID; // Translated language ID
    sValue2:  String; // Translated value
  end;

   // Translation repository entry list, sorted by wLangID1, sValue1, wLangID2
  TTranRepositoryEntries = class(TList)
  private
     // Tries to find the entry; returns True, if succeeded, and its index in iIndex; otherwise returns False
     //   and its adviced insertion-point index in iIndex
    function  FindTranslation(wLangID1, wLangID2: LANGID; const sValue1: String; out iIndex: Integer): Boolean;
     // Returns entry comparison result
    function  CompareEntries(p1, p2: PTranRepositoryEntry): Integer;
     // Prop handlers
    function  GetItems(Index: Integer): PTranRepositoryEntry;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
     // Adds or replaces the entry. Returns its index
    function  Add(wLangID1, wLangID2: LANGID; const sValue1, sValue2: String): Integer;
     // Props
     // -- Items by index
    property Items[Index: Integer]: PTranRepositoryEntry read GetItems; default;
  end;

   //===================================================================================================================
   // A translation repository
   //===================================================================================================================

  TTranRepository = class(TObject)
  private
     // Entry list
    FEntries: TTranRepositoryEntries;
     // Prop handlers
    function  GetTranslations(wLangID1, wLangID2: LANGID; const sValue1: String): String;
    procedure SetTranslations(wLangID1, wLangID2: LANGID; const sValue1, sValue2: String);
    function  GetEntryCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
     // Loading and saving to file
    procedure LoadFromFile(const sFileName: String);
    procedure SaveToFile(const sFileName: String);
     // Props
     // -- Repository entry count
    property EntryCount: Integer read GetEntryCount;
     // -- Returns the translation of sValue1 from wLangID1 into wLangID2, or an empty string if no translation found
    property Translations[wLangID1, wLangID2: LANGID; const sValue1: String]: String read GetTranslations write SetTranslations;
  end;

const
  S_CRLF                           = #13#10;

  SAppProductSID                   = 'dktraned';
  SAppCaption                      = 'DKLang Translation Editor';
  SAppVersion                      = 'v2.2';
  SAppVersionSID                   = '2.2';
  SAppEmail                        = 'devtools@narod.ru';

  SRepositoryFileHeader            = SAppCaption+' '+SAppVersion+' Translation Repository File';

  SLangSourceFileExt               = 'dklang';
  SLangSourceFileDotExt            = '.'+SLangSourceFileExt;
  STranFileExt                     = 'lng';
  STranFileDefaultName             = 'untitled.'+STranFileExt;
  SRepositoryFileName              = 'DKTranEd.dat';

   // Registry paths
  SRegKey_Root                     = 'Software\DKSoftware\DKTranEd';
  SRegKey_Toolbars                 = SRegKey_Root+'\Toolbars';
  SRegSection_MainWindow           = 'MainWindow';
  SRegSection_MRUSource            = 'MRUSource';
  SRegSection_MRUDisplay           = 'MRUDisplay';
  SRegSection_MRUTranslation       = 'MRUTranslation';
  SRegSection_MRUTargetApp         = 'MRUTargetApp'; 
  SRegSection_Preferences          = 'Preferences';

   // Language file relative path
  SLanguageRelPath                 = 'Language';

   // Main tree column indexes
  IColIdx_Name                     = 0;
  IColIdx_ID                       = 1;
  IColIdx_Original                 = 2;
  IColIdx_Translated               = 3;

   // Status bar panel indexes
  ISBPanelIdx_Main                 = 0;
  ISBPanelIdx_CompCount            = 1;
  ISBPanelIdx_PropCount            = 2;
  ISBPanelIdx_ConstCount           = 3;
  ISBPanelIdx_ReposEntryCount      = 4;

   // Colors
  CBack_CompEntry                  = $ffe5ec;  // Background color of component entry
  CBack_PropEntry                  = clWindow; // Background color of property entry
  CBack_ConstsNode                 = $eaeaff;  // Background color of 'Constants' node
  CBack_ConstEntry                 = clWindow; // Background color of constant entry
  CBack_UntranslatedValue          = $f0f0f0;  // Background color of untranslated item values

   // ImageIndices                 
  iiSettings                       =  0;
  iiFolder                         =  1;
  iiNew                            =  2;
  iiOpen                           =  3;
  iiSave                           =  4;
  iiSaveAs                         =  5;
  iiExit                           =  6;
  iiAbout                          =  7;
  iiJumpPrevUntranslated           =  8;
  iiJumpNextUntranslated           =  9;
  iiHelp                           = 10;
  iiClose                          = 11;
  iiNode_Comp                      = 12;
  iiNode_Consts                    = 13;
  iiNode_Prop                      = 14;
  iiNode_Const                     = 15;
  iiTranslated                     = 16;
  iiUntranslated                   = 17;
  iiJumpPrev                       = 18;
  iiJumpNext                       = 19;

var
   // Main tree code page
  cTreeCodePage: Cardinal;
   // Settings
  sSetting_InterfaceFont:     String;
  sSetting_TableFont:         String;
  sSetting_RepositoryDir:     String;
  bSetting_ReposRemovePrefix: Boolean;
  bSetting_ReposAutoAdd:      Boolean;
   // A global IDKWeb instance
  DKWeb: IDKWeb;

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

  function  ConstVal(const sName: String): String;

   // Returns the part of s before any delimiter char from sDelimiters
  function  GetFirstWord(const s, sDelimiters: String): String;
   // The same as GetFirstWord() but strips off from s the part being returned
  function  ExtractFirstWord(var s: String; const sDelimiters: String): String;

   // Checks that the specified file exists. If not, raises an Exception
  procedure CheckFileExists(const sFileName: String);
   // Set or get the Integer(ComboBox.Items.Objects[]) for the currently selected item. -1 means no item selected
  procedure SetCBObject(ComboBox: TComboBox; iID: Integer);
  function  GetCBObject(ComboBox: TComboBox): Integer;
   // Activates specified VT node if possible
  procedure ActivateVTNode(Tree: TBaseVirtualTree; Node: PVirtualNode; bScrollIntoView, bCenter: Boolean);
   // Enables or disables the given control and changes its color for clBtnFace (for disabled) or clWindow (otherwise)
  procedure EnableWndCtl(Ctl: TWinControl; bEnable: Boolean);
   // Font to string and back conversion
  function  FontToStr(Font: TFont): String;
  procedure FontFromStr(Font: TFont; const sFont: String);
   // Shows Select font dialog. Returns True if user clicked OK
  function  SelectFont(var sFont: String): Boolean;
   // Translates charset into code page
  function  CharsetToCP(Charset: TFontCharset): Cardinal;
   // Transformations Ansi<->Unicode
  function  AnsiToUnicodeCP(const s: AnsiString; cCodePage: Cardinal): WideString;
  function  UnicodeToAnsiCP(const s: WideString; cCodePage: Cardinal): AnsiString;

   // Strips off the prefix char if so configured in the repository settings
  function ReposFixPrefixChar(const s: String): String;

implementation
uses TypInfo, Forms, Dialogs;

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
    Application.MessageBox(PChar(sMessage), PChar(ConstVal('SDlgTitle_Info')), MB_OK or MB_ICONINFORMATION);
  end;

  procedure Error(const sMessage: String);
  begin
    Application.MessageBox(PChar(sMessage), PChar(ConstVal('SDlgTitle_Error')), MB_OK or MB_ICONERROR);
  end;

  function Confirm(const sMessage: String): Boolean;
  begin
    Result := Application.MessageBox(PChar(sMessage), PChar(ConstVal('SDlgTitle_Confirm')), MB_OKCANCEL or MB_ICONQUESTION)=IDOK;
  end;

  function ConstVal(const sName: String): String;
  begin
    Result := LangManager.ConstantValue[sName];
  end;

  function GetFirstWord(const s, sDelimiters: String): String;
  var i: Integer;
  begin
    i := 1;
    while (i<=Length(s)) and (Pos(s[i], sDelimiters)=0) do Inc(i);
    Result := Copy(s, 1, i-1);
  end;

  function ExtractFirstWord(var s: String; const sDelimiters: String): String;
  begin
    Result := GetFirstWord(s, sDelimiters);
    Delete(s, 1, Length(Result)+1);
  end;

  procedure CheckFileExists(const sFileName: String);
  begin
    if not FileExists(sFileName) then raise Exception.CreateFmt(ConstVal('SErrMsg_FileDoesntExist'), [sFileName]);
  end;

  procedure SetCBObject(ComboBox: TComboBox; iID: Integer);
  begin
    with ComboBox do
      if iID<0 then ItemIndex := -1 else ItemIndex := Items.IndexOfObject(Pointer(iID));
  end;

  function GetCBObject(ComboBox: TComboBox): Integer;
  begin
    Result := ComboBox.ItemIndex;
    if Result>=0 then Result := Integer(ComboBox.Items.Objects[Result]);
  end;

  procedure ActivateVTNode(Tree: TBaseVirtualTree; Node: PVirtualNode; bScrollIntoView, bCenter: Boolean);
  begin
    Tree.BeginUpdate;
    try
      Tree.ClearSelection;
      Tree.FocusedNode := Node;
      Tree.Selected[Node] := True;
      if bScrollIntoView and (Node<>nil) then Tree.ScrollIntoView(Node, bCenter, False);
    finally
      Tree.EndUpdate;
    end;
  end;

  procedure EnableWndCtl(Ctl: TWinControl; bEnable: Boolean);
  var pi: PPropInfo;
  begin
    Ctl.Enabled := bEnable;
    pi := GetPropInfo(Ctl, 'Color', [tkInteger]);
    if pi<>nil then SetOrdProp(Ctl, pi, iif(bEnable, clWindow, clBtnFace));
  end;

  function FontToStr(Font: TFont): String;
  begin
    with Font do Result := Format('%s/%d/%d/%d/%d', [Name, Size, Byte(Style), Color, Charset]);
  end;

  procedure FontFromStr(Font: TFont; const sFont: String);
  var s: String;
  begin
    s := sFont;
    with Font do begin
      Name    := ExtractFirstWord(s, '/');
      Size    := StrToIntDef(ExtractFirstWord(s, '/'), 10);
      Style   := TFontStyles(Byte(StrToIntDef(ExtractFirstWord(s, '/'), 0)));
      Color   := StrToIntDef(ExtractFirstWord(s, '/'), 0);
      Charset := StrToIntDef(ExtractFirstWord(s, '/'), DEFAULT_CHARSET);
    end;
  end;

  function  SelectFont(var sFont: String): Boolean;
  begin
    with TFontDialog.Create(nil) do
      try      
        FontFromStr(Font, sFont);
        Result := Execute;
        if Result then sFont := FontToStr(Font);
      finally
        Free;
      end;
  end;

  function CharsetToCP(Charset: TFontCharset): Cardinal;
  begin
    case Charset of
      VIETNAMESE_CHARSET,
        ANSI_CHARSET:      Result := 1252; // Windows 3.1 Latin 1 (US, Western Europe) or Vietnam
      SHIFTJIS_CHARSET:    Result := 932;  // Japan
      HANGEUL_CHARSET,
        JOHAB_CHARSET:     Result := 949;  // Korean
      GB2312_CHARSET:      Result := 936;  // Chinese (PRC, Singapore)
      CHINESEBIG5_CHARSET: Result := 950;  // Chinese (Taiwan, Hong Kong)
      HEBREW_CHARSET:      Result := 1255; // Hebrew
      ARABIC_CHARSET:      Result := 1256; // Arabic
      GREEK_CHARSET:       Result := 1253; // Windows 3.1 Greek
      TURKISH_CHARSET:     Result := 1254; // Windows 3.1 Turkish
      THAI_CHARSET:        Result := 874;  // Thai
      EASTEUROPE_CHARSET:  Result := 1250; // Windows 3.1 Eastern European
      RUSSIAN_CHARSET:     Result := 1251; // Windows 3.1 Cyrillic
      BALTIC_CHARSET:      Result := 1257; // Baltic
      SYMBOL_CHARSET:      Result := CP_SYMBOL;
      MAC_CHARSET:         Result := CP_MACCP;
      OEM_CHARSET:         Result := CP_OEMCP;
      else                 Result := CP_ACP;
    end;
  end;

  function AnsiToUnicodeCP(const s: AnsiString; cCodePage: Cardinal): WideString;
  var iLen: Integer;
  begin
    iLen := Length(s);
    SetLength(Result, iLen);
    MultiByteToWideChar(cCodePage, 0, @s[1], iLen, @Result[1], iLen);
  end;

  function UnicodeToAnsiCP(const s: WideString; cCodePage: Cardinal): AnsiString;
  var iLen: Integer;
  begin
    iLen := Length(s);
    SetLength(Result, iLen);
    WideCharToMultiByte(cCodePage, 0, @s[1], iLen, @Result[1], iLen, nil, nil);
  end;

  function ReposFixPrefixChar(const s: String): String;
  var
    i: Integer;
    bDblAmp: Boolean;
  begin
    Result := s;
    if bSetting_ReposRemovePrefix then begin
      i := 1;
      while i<Length(Result) do
        if Result[i]='&' then begin
          bDblAmp := (i<Length(Result)) and (Result[i+1]='&');
          if bDblAmp then Inc(i, 2) else Delete(Result, i, 1);
        end else
          Inc(i);
    end;
  end;

   //===================================================================================================================
   // TPropertySources
   //===================================================================================================================

  function TPropertySources.Add(iID: Integer; const sPropName, sValue: String): Integer;
  var p: PPropertySource;
  begin
     // Check ID uniqueness and find insertion point
    if FindID(iID, Result) then TranEdError(ConstVal('SErrMsg_DuplicatePropID'), [iID]);
     // Check name uniqueness
    if IndexOfPropName(sPropName)>=0 then TranEdError(ConstVal('SErrMsg_DuplicatePropName'), [sPropName]);
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
    if not IsValidIdent(sCompName) then TranEdError(ConstVal('SErrMsg_InvalidCompName'), [sCompName]);
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
    if FindCompName(Item.CompName, Result) then TranEdError(ConstVal('SErrMsg_DuplicateCompName'), [Item.CompName]);
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

  function TLangSource.CompareStructureWith(Translations: TDKLang_CompTranslations; out iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer): String;
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
        Inc(iCntProps, SrcComp.PropertySources.Count);
         // Try to find the component in translation
        TranComp := Translations.FindComponentName(SrcComp.CompName);
         // If not found
        if TranComp=nil then begin
           // Add the component to Translations
          TranComp := TDKLang_CompTranslation.Create(SrcComp.CompName);
          Translations.Add(TranComp);
           // Log the difference
          AddLine(ConstVal('SDiffDesc_AddComponent'), [SrcComp.CompName]);
          Inc(iCntAddedComps);
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
            TranComp.Add(pSrcProp.iID, pSrcProp.sValue, [dktsUntranslated]);
             // Log the difference
            AddLine('    '+ConstVal('SDiffDesc_AddProperty'), [pSrcProp.sPropName, pSrcProp.iID]);
            Inc(iCntAddedProps);
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
          Translations.Constants.Add(pSrcConst.sName, pSrcConst.sDefValue, [dktsUntranslated]);
           // Log the difference
          AddLine(ConstVal('SDiffDesc_AddConstant'), [pSrcConst.sName]);
          Inc(iCntAddedConsts);
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
          AddLine(ConstVal('SDiffDesc_RemoveComponent'), [TranComp.ComponentName]);
          Inc(iCntRemovedComps);
          Inc(iCntRemovedProps, TranComp.Count);
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
              AddLine(ConstVal('SDiffDesc_RemoveProperty'), [TranComp.ComponentName, pTranProp.iID]);
              Inc(iCntRemovedProps);
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
          AddLine(ConstVal('SDiffDesc_RemoveConstant'), [pTranConst.sName]);
          Inc(iCntRemovedConsts);
           // Remove the constant from Translations
          Translations.Constants.Remove(pTranConst);
        end else
          Inc(iConst);
      end;
    end;

  begin
    Result := '';
    iCntAddedComps    := 0;
    iCntAddedProps    := 0;
    iCntAddedConsts   := 0;
    iCntRemovedComps  := 0;
    iCntRemovedProps  := 0;
    iCntRemovedConsts := 0;
    iCntComps         := FComponentSources.Count;
    iCntProps         := 0;
    iCntConsts        := FConstants.Count;
     // Check missing entries
    sText := '';
    CheckMissingComps;
    CheckMissingConsts;
    if sText<>'' then Result := Result+ConstVal('SDiffDesc_MissingEntries')+S_CRLF+sText+S_CRLF;
     // Check excessive entries
    sText := '';
    CheckExcessiveComps;
    CheckExcessiveConsts;
    if sText<>'' then Result := Result+ConstVal('SDiffDesc_ExcessiveEntries')+S_CRLF+sText+S_CRLF;
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
      if iBracket=0 then TranEdError(ConstVal('SErrMsg_CharMissing'), [']']);
      if iBracket<>Length(sLine) then TranEdError(ConstVal('SErrMsg_WrongSectionName'), [sLine]);
       // Extract section name
      sSectionName := Trim(Copy(sLine, 2, Length(sLine)-2));
      if sSectionName='' then TranEdError(ConstVal('SErrMsg_SectionNameMissing'));
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
      if iEq=0 then TranEdError(ConstVal('SErrMsg_CharMissing'), ['=']);
       // Parse constant name
      sConstName := Trim(Copy(sLine, 1, iEq-1));
      if sConstName='' then TranEdError(ConstVal('SErrMsg_ConstNameMissing'));
       // Extract constant value and add the constant to the list
      FConstants.Add(sConstName, DecodeControlChars(Trim(Copy(sLine, iEq+1, MaxInt))), []);
    end;

    procedure ParseProperty;
    var
      iEq, iComma, iID: Integer;
      sPropName, sIDVal: String;
    begin
       // Check whether there was a section before
      if Comp=nil then TranEdError(ConstVal('SErrMsg_SectionlessEntry'));
       // Check '='
      iEq := Pos('=', sLine);
      if iEq=0 then TranEdError(ConstVal('SErrMsg_CharMissing'), ['=']);
       // Parse property name
      sPropName := Trim(Copy(sLine, 1, iEq-1));
      if sPropName='' then TranEdError(ConstVal('SErrMsg_PropNameMissing'));
       // Extract ID & value
      sIDVal := Trim(Copy(sLine, iEq+1, MaxInt));
       // Parse ID
      iComma := Pos(',', sIDVal);
      if (sIDVal='') or (iComma=1) then TranEdError(ConstVal('SErrMsg_PropIDMissing'));
      if iComma=0 then TranEdError(ConstVal('SErrMsg_CharMissing'), [',']);
      iID := StrToIntDef(Copy(sIDVal, 1, iComma-1), 0);
      if iID<=0 then TranEdError(ConstVal('SErrMsg_PropIDInvalid'));
       // Extract value and add the property
      Comp.PropertySources.Add(iID, sPropName, DecodeControlChars(Trim(Copy(sIDVal, iComma+1, MaxInt))));
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
        on e: ETranEdError do TranEdError(ConstVal('SErrMsg_LoadLangSourceFailed'), [iLine+1, e.Message]);
      end;
    end;
  end;

   //===================================================================================================================
   // TTranRepositoryEntries
   //===================================================================================================================

  function TTranRepositoryEntries.Add(wLangID1, wLangID2: LANGID; const sValue1, sValue2: String): Integer;
  var p: PTranRepositoryEntry;
  begin
     // Try to find an existing entry
    if FindTranslation(wLangID1, wLangID2, sValue1, Result) then
      p := GetItems(Result)
     // If not found - add new one 
    else begin
      New(p);
      Insert(Result, p);
      p.wLangID1 := wLangID1;
      p.sValue1  := sValue1;
      p.wLangID2 := wLangID2;
    end;
     // Set the translated value
    p.sValue2 := sValue2;
  end;

  function TTranRepositoryEntries.CompareEntries(p1, p2: PTranRepositoryEntry): Integer;
  begin
     // Compare wLangID1
    Result := Integer(p1.wLangID1)-Integer(p2.wLangID1);
     // Compare sValue1
    if Result=0 then Result := AnsiCompareStr(p1.sValue1, p2.sValue1);
     // Compare wLangID2
    if Result=0 then Result := Integer(p1.wLangID2)-Integer(p2.wLangID2);
  end;

  function TTranRepositoryEntries.FindTranslation(wLangID1, wLangID2: LANGID; const sValue1: String; out iIndex: Integer): Boolean;
  var
    iL, iR, i: Integer;
    TRE: TTranRepositoryEntry;
  begin
    TRE.wLangID1 := wLangID1;
    TRE.sValue1  := sValue1;
    TRE.wLangID2 := wLangID2;
     // Since the list is sorted, implement binary search here
    Result := False;
    iL := 0;
    iR := Count-1;
    while iL<=iR do begin
      i := (iL+iR) shr 1;
      case CompareEntries(GetItems(i), @TRE) of
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

  function TTranRepositoryEntries.GetItems(Index: Integer): PTranRepositoryEntry;
  begin
    Result := Get(Index);
  end;

  procedure TTranRepositoryEntries.Notify(Ptr: Pointer; Action: TListNotification);
  begin
    if Action=lnDeleted then Dispose(PTranRepositoryEntry(Ptr));
  end;

   //===================================================================================================================
   // TTranRepository
   //===================================================================================================================

  constructor TTranRepository.Create;
  begin
    inherited Create;
    FEntries := TTranRepositoryEntries.Create;
  end;

  destructor TTranRepository.Destroy;
  begin
    FEntries.Free;
    inherited Destroy;
  end;

  function TTranRepository.GetEntryCount: Integer;
  begin
    Result := FEntries.Count;
  end;

  function TTranRepository.GetTranslations(wLangID1, wLangID2: LANGID; const sValue1: String): String;
  var idx: Integer;
  begin
    if FEntries.FindTranslation(wLangID1, wLangID2, sValue1, idx) then Result := FEntries[idx].sValue2 else Result := '';
  end;

  procedure TTranRepository.LoadFromFile(const sFileName: String);
  var
    SLLines, SL: TStringList;
    i: Integer;

    procedure ParseLine(const sLine: String);
    begin
       // Skip empty lines or comments
      if (sLine='') or (sLine[1]=';') then Exit;
       // Parse comma-delimited line
      SL.CommaText := sLine;
       // Check each entry pair in SLTerm
      if SL.Count>=4 then Translations[StrToIntDef(SL[0], 0), StrToIntDef(SL[2], 0), DecodeControlChars(Trim(SL[1]))] := DecodeControlChars(Trim(SL[3]));
    end;

  begin
    FEntries.Clear;
    if not FileExists(sFileName) then Exit;
    SLLines := TStringList.Create;
    try
       // Load the stream into TStringList
      SLLines.LoadFromFile(sFileName);
       // Parse the strings
      SL := TStringList.Create;
      try
        for i := 0 to SLLines.Count-1 do ParseLine(SLLines[i]);
      finally
        SL.Free;
      end;
    finally
      SLLines.Free;
    end;
  end;

  procedure TTranRepository.SaveToFile(const sFileName: String);
  var
    fs: TFileStream;
    i: Integer;
    SL: TStringList;
    p: PTranRepositoryEntry;

    procedure WriteLine(const sLine: String);
    begin
      fs.WriteBuffer(sLine[1],  Length(sLine));
      fs.WriteBuffer(S_CRLF[1], Length(S_CRLF));
    end;

  begin
    fs := TFileStream.Create(sFileName, fmCreate);
    try
       // Write the header comment
      WriteLine('; '+SRepositoryFileHeader);
      WriteLine('; '+DKWeb.MainSiteURI);
      WriteLine('');
       // Create temporary entry string list (which represents one line in the repository file)
      SL := TStringList.Create;
      try
        for i := 0 to FEntries.Count-1 do begin
          p := FEntries[i];
           // Fill SL with pairs LangID-Value
          SL.Clear;
          SL.Add(IntToStr(p.wLangID1));
          SL.Add(EncodeControlChars(p.sValue1));
          SL.Add(IntToStr(p.wLangID2));
          SL.Add(EncodeControlChars(p.sValue2));
           // Write the entry line
          WriteLine(SL.CommaText);
        end;
      finally
        SL.Free;
      end;
    finally
      fs.Free;
    end;
  end;

  procedure TTranRepository.SetTranslations(wLangID1, wLangID2: LANGID; const sValue1, sValue2: String);
  begin
    if (wLangID1<>0) and (wLangID2<>0) and (sValue1<>'') and (sValue2<>'') then FEntries.Add(wLangID1, wLangID2, sValue1, sValue2);
  end;

initialization
  DKWeb := DKCreateDKWeb(SAppProductSID, SAppVersionSID);
  LangManager.ScanForLangFiles(ExtractFilePath(ParamStr(0))+SLanguageRelPath, '*.lng', True);
finalization
  DKWeb := nil;
end.
