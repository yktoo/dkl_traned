unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, XPMan, DKLang, ConsVars,
  Placemnt, ImgList, TB2Item, ActnList, VirtualTrees, ExtCtrls,
  TBXStatusBars, TBX, TB2Dock, TB2Toolbar, TB2MRU, TBXDkPanels, StdCtrls,
  Menus;

type
   // Tree node kind
  TNodeKind = (
    nkNone,   // No node
    nkComp,   // Component node
    nkProp,   // Property node (a child of a component node)
    nkConsts, // 'Constants' node
    nkConst); // Constant node (a child of 'Constants' node)

   // Data stored in Nodes
  PNodeData = ^TNodeData;
  TNodeData = record
    Kind: TNodeKind;  // Node kind
    case TNodeKind of
      nkComp: (
        CompSource: TComponentSource;              // Link to component source
        DisplComp:  TDKLang_CompTranslation;       // Link to display-component-translation
        TranComp:   TDKLang_CompTranslation);      // Link to component translation
      nkProp: (
        pSrcProp:   PPropertySource;               // Link to property source
        pDisplProp: PDKLang_PropValueTranslation;  // Link to display-property-translation
        pTranProp:  PDKLang_PropValueTranslation); // Link to property translation
      nkConst: (
        pSrcConst:   PDKLang_Constant;              // Link to constant source
        pDisplConst: PDKLang_Constant;              // Link to display-constant-translation
        pTranConst:  PDKLang_Constant);             // Link to constant translation
  end;

  TfMain = class(TForm)
    aAbout: TAction;
    aClose: TAction;
    aExit: TAction;
    aJumpNextUntranslated: TAction;
    aJumpPrevUntranslated: TAction;
    alMain: TActionList;
    aNewOrOpen: TAction;
    aSave: TAction;
    aSaveAs: TAction;
    aSettings: TAction;
    aTranProps: TAction;
    bAbout: TTBXItem;
    bExit: TTBXItem;
    bJumpNextUntranslated: TTBXItem;
    bJumpPrevUntranslated: TTBXItem;
    bNewOrOpen: TTBXItem;
    bSave: TTBXItem;
    bSaveAs: TTBXItem;
    dkBottom: TTBXDock;
    dkLeft: TTBXDock;
    dkRight: TTBXDock;
    dkTop: TTBXDock;
    fpMain: TFormPlacement;
    iAbout: TTBXItem;
    iClose: TTBXItem;
    iExit: TTBXItem;
    iFileSep: TTBXSeparatorItem;
    iJumpNextUntranslated: TTBXItem;
    iJumpPrevUntranslated: TTBXItem;
    ilMain: TTBImageList;
    iNewOrOpen: TTBXItem;
    iSave: TTBXItem;
    iSaveAs: TTBXItem;
    iSepJumpPrevUntranslated: TTBXSeparatorItem;
    iSettings: TTBXItem;
    iToggleStatusBar: TTBXVisibilityToggleItem;
    iToggleToolbar: TTBXVisibilityToggleItem;
    iTranProps: TTBXItem;
    iViewSep1: TTBXSeparatorItem;
    MRUDisplay: TTBMRUList;
    MRUSource: TTBMRUList;
    MRUTran: TTBMRUList;
    pMain: TPanel;
    sbarMain: TTBXStatusBar;
    smEdit: TTBXSubmenuItem;
    smFile: TTBXSubmenuItem;
    smHelp: TTBXSubmenuItem;
    smLanguage: TTBXSubmenuItem;
    smView: TTBXSubmenuItem;
    tbMain: TTBXToolbar;
    tbMenu: TTBXToolbar;
    tbSep1: TTBXSeparatorItem;
    tbSep2: TTBXSeparatorItem;
    tvMain: TVirtualStringTree;
    dpCurrentEntry: TTBXDockablePanel;
    mCurSrcEntry: TMemo;
    mCurTranEntry: TMemo;
    iToggleCurrentEntry: TTBXVisibilityToggleItem;
    bTranProps: TTBXItem;
    bSettings: TTBXItem;
    aMarkTranslated: TAction;
    aMarkUntranslated: TAction;
    iMarkUntranslated: TTBXItem;
    iMarkTranslated: TTBXItem;
    pmTree: TTBXPopupMenu;
    pmView: TTBXPopupMenu;
    ipmMarkTranslated: TTBXItem;
    ipmMarkUntranslated: TTBXItem;
    ipmJumpPrevUntranslated: TTBXItem;
    ipmJumpNextUntranslated: TTBXItem;
    ipmTreeSep: TTBXSeparatorItem;
    ipmTranProps: TTBXItem;
    aWebsite: TAction;
    iWebsite: TTBXItem;
    aAddToRepository: TAction;
    aAutoTranslate: TAction;
    smTools: TTBXSubmenuItem;
    iAutoTranslate: TTBXItem;
    iAddToRepository: TTBXItem;
    iToolsSep: TTBXSeparatorItem;
    procedure aaAbout(Sender: TObject);
    procedure aaClose(Sender: TObject);
    procedure aaExit(Sender: TObject);
    procedure aaNewOrOpen(Sender: TObject);
    procedure aaSave(Sender: TObject);
    procedure aaSaveAs(Sender: TObject);
    procedure aaSettings(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fpMainRestorePlacement(Sender: TObject);
    procedure fpMainSavePlacement(Sender: TObject);
    procedure tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure tvMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure aaTranProps(Sender: TObject);
    procedure aaJumpPrevUntranslated(Sender: TObject);
    procedure aaJumpNextUntranslated(Sender: TObject);
    procedure dpCurrentEntryResize(Sender: TObject);
    procedure mCurTranEntryChange(Sender: TObject);
    procedure tvMainEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure aaMarkUntranslated(Sender: TObject);
    procedure aaMarkTranslated(Sender: TObject);
    procedure aaWebsite(Sender: TObject);
    procedure aaAddToRepository(Sender: TObject);
    procedure aaAutoTranslate(Sender: TObject);
  private
     // Language source storage
    FLangSource: TLangSource;
     // Translations used for display; nil if no translation was open
    FDisplayTranslations: TDKLang_CompTranslations;
     // Loaded or new translations
    FTranslations: TDKLang_CompTranslations;
     // Source and target translation language
    FLangIDSource: LANGID;
    FLangIDTran: LANGID;
     // Flag that command line parameters have been checked
    FCmdLineChecked: Boolean;
     // Update current entry editor flag
    FUpdatingCurEntryEditor: Boolean;
     // Translation repository
    FRepository: TTranRepository;
     // Prop storage
    FModified: Boolean;
    FTranFileName: String;
    FSourceFileName: String;
    FDisplayFileName: String;
     // Redisplays the language source tree
    procedure UpdateTree;
     // Updates current entry panel contents
    procedure UpdateCurEntry;
     // Checks whether translation file is modified and asks to save it
    function  CheckSave: Boolean;
     // Uses the specified file names as suggested, shows select files dialog and loads the files. Returns True if user
     //   clicked OK
    function  OpenFiles(const sLangSrcFileName, sDisplayFileName, sTranFileName: String): Boolean;
     // File loading/saving
    procedure DoLoad(const sLangSrcFileName, sDisplayFileName, sTranFileName: String);
    procedure DoSave(const sFileName: String);
     // Updates form caption
    procedure UpdateCaption;
     // Adjusts Actions availability
    procedure EnableActions;
     // Closes all project data. If bUpdateDisplay=True, also updates the displayed items
    procedure CloseProject(bUpdateDisplay: Boolean);
     // Return the kind of Node
    function  GetNodeKind(Node: PVirtualNode): TNodeKind;
     // Returns True if node is a value still untranslated
    function  IsNodeUntranslated(Node: PVirtualNode): Boolean;
     // Tries to locate the next (bNext=True) or previous (bNext=False) untranslated node
    procedure LocateUntranslatedNode(bNext: Boolean);
     // Initially adjusts the VT column widths
    procedure AdjustVTColumnWidth;
     // App events
    procedure AppHint(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
     // Applies current setting
    procedure ApplySettings;
     // Updates status bar info
    procedure UpdateStatusBar;
     // Marks selected entries translated (bTranslated=True) or untranslated (bTranslated=False)
    procedure MarkTranslated(bTranslated: Boolean);
     // Adds translation for Node to translation repository, if possible
    procedure AddNodeTranslationToRepository(Node: PVirtualNode);
     // Translates the Node by using translation repository, if possible
    procedure TranslateNodeFromRepository(Node: PVirtualNode);
     // Prop handlers
    procedure SetModified(Value: Boolean);
    procedure SetTranFileName(const Value: String);
    function  GetDisplayTranFileName: String;
  public
     // Props
     // -- Name of the file used for display-translation. Empty string if no such translation was open
    property DisplayFileName: String read FDisplayFileName;
     // -- Displayed name of translation file currently open
    property DisplayTranFileName: String read GetDisplayTranFileName;
     // -- True, if editor contents was saved since last save
    property Modified: Boolean read FModified write SetModified;
     // -- Name of the language source file currently open
    property SourceFileName: String read FSourceFileName;
     // -- Name of the translation file currently open
    property TranFileName: String read FTranFileName write SetTranFileName;
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses Registry, ShellAPI, udSettings, udAbout, udOpenFiles, udDiffLog, udTranProps;

   //===================================================================================================================
   //  TfMain
   //===================================================================================================================

  procedure TfMain.aaAbout(Sender: TObject);
  begin
    ShowAbout;
  end;

  procedure TfMain.aaAddToRepository(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetFirstSelected;
    while n<>nil do begin
      AddNodeTranslationToRepository(n);
      n := tvMain.GetNextSelected(n);
    end;
    UpdateStatusBar;
  end;

  procedure TfMain.aaAutoTranslate(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetFirstSelected;
    while n<>nil do begin
      TranslateNodeFromRepository(n);
      n := tvMain.GetNextSelected(n);
    end;
     // Update display
    tvMain.Invalidate;
    UpdateStatusBar;
  end;

  procedure TfMain.aaClose(Sender: TObject);
  begin
    CloseProject(True);
  end;

  procedure TfMain.aaExit(Sender: TObject);
  begin
    Close;
  end;

  procedure TfMain.aaJumpNextUntranslated(Sender: TObject);
  begin
    LocateUntranslatedNode(True);
  end;

  procedure TfMain.aaJumpPrevUntranslated(Sender: TObject);
  begin
    LocateUntranslatedNode(False);
  end;

  procedure TfMain.aaMarkTranslated(Sender: TObject);
  begin
    MarkTranslated(True);
  end;

  procedure TfMain.aaMarkUntranslated(Sender: TObject);
  begin
    MarkTranslated(False);
  end;

  procedure TfMain.aaNewOrOpen(Sender: TObject);
  begin
    OpenFiles(FSourceFileName, FDisplayFileName, FTranFileName);
  end;

  procedure TfMain.aaSave(Sender: TObject);
  begin
    if FTranFileName='' then aaSaveAs(Sender) else DoSave(FTranFileName);
  end;

  procedure TfMain.aaSaveAs(Sender: TObject);
  begin
    with TSaveDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := STranFileFilter;
        Options    := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
        Title      := SDlgTitle_SaveTranFileAs;
        FileName   := DisplayTranFileName;
        if Execute then DoSave(FileName);
      finally
        Free;
      end;
  end;

  procedure TfMain.aaSettings(Sender: TObject);
  begin
    if EditSettings then ApplySettings;
  end;

  procedure TfMain.aaTranProps(Sender: TObject);
  begin
    if EditTranslationProps(FTranslations, FLangIDSource, FLangIDTran) then Modified := True;
  end;

  procedure TfMain.aaWebsite(Sender: TObject);
  begin
    ShellExecute(Handle, nil, PChar(SAppWebsite), nil, nil, SW_SHOWNORMAL);
  end;

  procedure TfMain.AddNodeTranslationToRepository(Node: PVirtualNode);
  var p: PNodeData;
  begin
    p := tvMain.GetNodeData(Node);
    if (p<>nil) and (FLangIDSource<>0) and (FLangIDTran<>0) and (FLangIDSource<>FLangIDTran) then
      case p.Kind of
        nkProp: if not (dklptsUntranslated in p.pTranProp.States) then
          FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcProp.sValue)]     := ReposFixPrefixChar(p.pTranProp.sValue);
        nkConst: if not (dklcsUntranslated in p.pTranConst.States) then
          FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcConst.sDefValue)] := ReposFixPrefixChar(p.pTranConst.sDefValue);
      end;
  end;

  procedure TfMain.AdjustVTColumnWidth;
  var i, iWidth: Integer;
  begin
     // Make the widths of all columns equal except for 'ID' column
    with tvMain.Header.Columns do begin
      iWidth := (tvMain.ClientWidth-Items[IColIdx_ID].Width) div (Count-1);
      for i := 0 to Count-1 do
        if i<>IColIdx_ID then Items[i].Width := iWidth;
    end;
  end;

  procedure TfMain.AppHint(Sender: TObject);
  begin
    sbarMain.Panels[ISBPanelIdx_Main].Caption := Application.Hint;
  end;

  procedure TfMain.AppIdle(Sender: TObject; var Done: Boolean);
  var
    i: Integer;
    sSrcFile, sDisplFile, sTranFile: String;

    procedure UseFile(const sFileName: String);
    var sExt: String;
    begin
      if sFileName<>'' then begin
        sExt := ExtractFileExt(sFileName);
         // If the file has language source file extension
        if AnsiSameText(sExt, SLangSourceFileDotExt) then begin
          if sSrcFile='' then sSrcFile := sFileName;
         // Else if translation file is empty, fill it with name supplied
        end else if sTranFile='' then
          sTranFile := sFileName
         // Else assume it a display-translation file name
        else if sDisplFile='' then
          sDisplFile := sFileName;
      end;
    end;

  begin
    if not FCmdLineChecked then begin
      FCmdLineChecked := True;
       // Check command line parameters
      sSrcFile   := '';
      sDisplFile := '';
      sTranFile  := '';
      for i := 1 to 3 do UseFile(ParamStr(i));
      if sSrcFile<>'' then DoLoad(sSrcFile, sDisplFile, sTranFile) else OpenFiles(sSrcFile, sDisplFile, sTranFile);
    end;
  end;

  procedure TfMain.ApplySettings;
  begin
     // Adjust interface font
    FontFromStr(Font, sSetting_InterfaceFont);
    ToolbarFont.Assign(Font);
     // Adjust table font
    FontFromStr(tvMain.Font, sSetting_TableFont);
    cTreeCodePage := CharsetToCP(tvMain.Font.Charset);
  end;

  function TfMain.CheckSave: Boolean;
  begin
    Result := not Modified;
    if not Result then
      case MessageBox(Handle, PChar(Format(SConfirm_FileNotSaved, [DisplayTranFileName])), PChar(SDlgTitle_Confirm), MB_ICONEXCLAMATION or MB_YESNOCANCEL) of
        IDYES: begin
          aSave.Execute;
          Result := not Modified;
        end;
        IDNO: Result := True;
      end;
  end;

  procedure TfMain.CloseProject(bUpdateDisplay: Boolean);
  begin
    FreeAndNil(FLangSource);
    FreeAndNil(FDisplayTranslations);
    FreeAndNil(FTranslations);
    FModified        := False;
    FSourceFileName  := '';
    FDisplayFileName := '';
    FTranFileName    := '';
    if bUpdateDisplay then begin
      UpdateCaption;
      UpdateTree;
    end;
  end;

  procedure TfMain.DoLoad(const sLangSrcFileName, sDisplayFileName, sTranFileName: String);
  var sDiff: String;
  begin
     // Destroy former langsource storage and translations
    CloseProject(True);
    try
       // Create (and load) new langsource
      FLangSource := TLangSource.Create(sLangSrcFileName);
       // Create and load, if needed, display-translations
      if sDisplayFileName<>'' then begin
        FDisplayTranslations := TDKLang_CompTranslations.Create;
        FDisplayTranslations.LoadFromFile(sDisplayFileName);
      end;
       // Create (and load, if needed) translations. Determine the languages
      FTranslations := TDKLang_CompTranslations.Create;
      if sTranFileName='' then begin
        FLangIDSource := ILangID_USEnglish;
        FLangIDTran   := 0;
      end else begin
        FTranslations.LoadFromFile(sTranFileName);
        FLangIDSource := StrToIntDef(FTranslations.Params.Values[SDKLang_TranParam_SourceLangID], ILangID_USEnglish);
        FLangIDTran   := StrToIntDef(FTranslations.Params.Values[SDKLang_TranParam_LangID],       0);
      end;
       // Now compare the source and the translation and update the latter
      sDiff := FLangSource.CompareStructureWith(FTranslations);
       // Show the differences unless this is a new translation
      if (sTranFileName<>'') and (sDiff<>'') then ShowDiffLog(sDiff);
       // Update the properties
      FModified        := False;
      FSourceFileName  := sLangSrcFileName;
      FDisplayFileName := sDisplayFileName;
      FTranFileName    := sTranFileName;
      MRUSource.Add(FSourceFileName);
      MRUDisplay.Add(FDisplayFileName);
      if FTranFileName<>'' then MRUTran.Add(FTranFileName);
      UpdateCaption;
       // Reload the tree
      UpdateTree;
       // If no languages specified or source and target languages are the same, show translation properties dialog
      if (FLangIDSource=0) or (FLangIDTran=0) or (FLangIDSource=FLangIDTran) then
        EditTranslationProps(FTranslations, FLangIDSource, FLangIDTran);
    except
       // Destroy the objects in a case of failure
      CloseProject(True);
      raise;
    end;
  end;

  procedure TfMain.DoSave(const sFileName: String);
  begin
     // Update translation parameter values
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_LangID]       := IntToStr(FLangIDSource);
      Values[SDKLang_TranParam_SourceLangID] := IntToStr(FLangIDTran);
      Values[SDKLang_TranParam_Generator]    := Format('%s %s', [SAppCaption, SAppVersion]);
      Values[SDKLang_TranParam_LastModified] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    end;
     // Save the translations
    FTranslations.SaveToFile(sFileName, True);
     // Update properties
    FModified := False;
    FTranFileName := sFileName;
    UpdateCaption;
     // Register translation in the MRU list
    MRUTran.Add(FTranFileName);
  end;

  procedure TfMain.dpCurrentEntryResize(Sender: TObject);
  begin
    mCurSrcEntry.Width := dpCurrentEntry.ClientWidth div 2;
  end;

  procedure TfMain.EnableActions;
  var bOpenFiles: Boolean;
  begin
    bOpenFiles := FLangSource<>nil;
    aSave.Enabled                 := bOpenFiles;
    aSaveAs.Enabled               := bOpenFiles;
    aClose.Enabled                := bOpenFiles;
    aTranProps.Enabled            := bOpenFiles;
    aJumpPrevUntranslated.Enabled := bOpenFiles;
    aJumpNextUntranslated.Enabled := bOpenFiles;
  end;

  procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    CanClose := CheckSave;
  end;

  procedure TfMain.FormCreate(Sender: TObject);
  begin
     // Adjust fpMain
    fpMain.IniFileName := SRegKey_Root;
    fpMain.IniSection  := SRegSection_MainWindow;
     // Adjust Application
    Application.OnHint := AppHint;
    Application.OnIdle := AppIdle;
     // Adjust tvMain
    tvMain.NodeDataSize := SizeOf(TNodeData);
     // Create the repository
    FRepository := TTranRepository.Create;
     // Update the tree
    UpdateTree;
  end;

  procedure TfMain.FormDestroy(Sender: TObject);
  begin
    CloseProject(False);
    FRepository.Free;
  end;

  procedure TfMain.fpMainRestorePlacement(Sender: TObject);
  var rif: TRegIniFile;
  begin
    rif := fpMain.RegIniFile;
     // Load toolbar props
    TBRegLoadPositions(Self, HKEY_CURRENT_USER, SRegKey_Root);
     // Restore MRUs
    MRUSource.LoadFromRegIni (rif, SRegSection_MRUSource);
    MRUDisplay.LoadFromRegIni(rif, SRegSection_MRUDisplay);
    MRUTran.LoadFromRegIni   (rif, SRegSection_MRUTranslation);
     // Load settings
    sSetting_InterfaceFont     := rif.ReadString(SRegSection_Preferences, 'InterfaceFont',     FontToStr(Font));
    sSetting_TableFont         := rif.ReadString(SRegSection_Preferences, 'TableFont',         sSetting_InterfaceFont);
    sSetting_RepositoryDir     := rif.ReadString(SRegSection_Preferences, 'RepositoryPath',    ExtractFileDir(ParamStr(0)));
    bSetting_ReposRemovePrefix := rif.ReadBool  (SRegSection_Preferences, 'ReposRemovePrefix', True);
    bSetting_ReposAutoAdd      := rif.ReadBool  (SRegSection_Preferences, 'ReposAutoAdd',      True);
     // Load the repository
    FRepository.FileLoad(IncludeTrailingPathDelimiter(sSetting_RepositoryDir)+SRepositoryFileName);
     // Apply loaded settings
    ApplySettings;
    UpdateStatusBar;
  end;

  procedure TfMain.fpMainSavePlacement(Sender: TObject);
  var rif: TRegIniFile;
  begin
    rif := fpMain.RegIniFile;
     // Save toolbar props
    TBRegSavePositions(Self, HKEY_CURRENT_USER, SRegKey_Toolbars);
     // Save MRUs
    MRUSource.SaveToRegIni (rif, SRegSection_MRUSource);
    MRUDisplay.SaveToRegIni(rif, SRegSection_MRUDisplay);
    MRUTran.SaveToRegIni   (rif, SRegSection_MRUTranslation);
     // Save settings
    rif.WriteString(SRegSection_Preferences, 'InterfaceFont',     sSetting_InterfaceFont);
    rif.WriteString(SRegSection_Preferences, 'TableFont',         sSetting_TableFont);
    rif.WriteString(SRegSection_Preferences, 'RepositoryPath',    sSetting_RepositoryDir);
    rif.WriteBool  (SRegSection_Preferences, 'ReposRemovePrefix', bSetting_ReposRemovePrefix);
    rif.WriteBool  (SRegSection_Preferences, 'ReposAutoAdd',      bSetting_ReposAutoAdd);
     // Save the repository
    FRepository.FileSave;
  end;

  function TfMain.GetDisplayTranFileName: String;
  begin
    Result := iif(FTranFileName='', STranFileDefaultName, FTranFileName);
  end;

  function TfMain.GetNodeKind(Node: PVirtualNode): TNodeKind;
  begin
    if Node=nil then Result := nkNone else Result := PNodeData(tvMain.GetNodeData(Node)).Kind;
  end;

  function TfMain.IsNodeUntranslated(Node: PVirtualNode): Boolean;
  var p: PNodeData;
  begin
    Result := False;
    p := tvMain.GetNodeData(Node);
    case p.Kind of
      nkProp:  Result := dklptsUntranslated in p.pTranProp.States;
      nkConst: Result := dklcsUntranslated  in p.pTranConst.States;
    end;
  end;

  procedure TfMain.LocateUntranslatedNode(bNext: Boolean);
  var Node: PVirtualNode;
  begin
     // Determine the start node for operation
    Node := tvMain.FocusedNode;
    if bNext then
      if Node=nil then Node := tvMain.GetFirst else Node := tvMain.GetNext(Node)
    else
      Node := tvMain.GetPrevious(Node);
     // Look for next/previous untranslated node 
    while Node<>nil do begin
      if IsNodeUntranslated(Node) then begin
        ActivateVTNode(tvMain, Node, True, True);
        Exit;
      end;
      if bNext then Node := tvMain.GetNext(Node) else Node := tvMain.GetPrevious(Node);
    end;
     // Beep if not found
    MessageBeep(MB_OK); 
  end;

  procedure TfMain.MarkTranslated(bTranslated: Boolean);
  var
    n: PVirtualNode;
    p: PNodeData;
  begin
    n := tvMain.GetFirstSelected;
    while n<>nil do begin
      p := tvMain.GetNodeData(n);
      case p.Kind of
        nkProp:  if bTranslated then Exclude(p.pTranProp.States,  dklptsUntranslated) else Include(p.pTranProp.States,  dklptsUntranslated);
        nkConst: if bTranslated then Exclude(p.pTranConst.States, dklcsUntranslated)  else Include(p.pTranConst.States, dklcsUntranslated);
      end;
      n := tvMain.GetNextSelected(n);
    end;
    tvMain.Invalidate;
    UpdateStatusBar;
  end;

  procedure TfMain.mCurTranEntryChange(Sender: TObject);
  begin
    if FUpdatingCurEntryEditor then Exit;
    tvMain.Text[tvMain.FocusedNode, IColIdx_Translated] := MultilineToLine(mCurTranEntry.Text);
  end;

  function TfMain.OpenFiles(const sLangSrcFileName, sDisplayFileName, sTranFileName: String): Boolean;
  var sSourceFile, sDisplayFile, sTranFile: String;
  begin
    sSourceFile  := sLangSrcFileName;
    sTranFile    := sTranFileName;
    sDisplayFile := sDisplayFileName;
    Result := SelectLangFiles(sSourceFile, sDisplayFile, sTranFile, MRUSource.Items, MRUDisplay.Items, MRUTran.Items);
    if Result then DoLoad(sSourceFile, sDisplayFile, sTranFile);
  end;

  procedure TfMain.SetModified(Value: Boolean);
  begin
    if FModified<>Value then begin
      FModified := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.SetTranFileName(const Value: String);
  begin
    if FTranFileName<>Value then begin
      FTranFileName := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.TranslateNodeFromRepository(Node: PVirtualNode);
  var
    p: PNodeData;
    s: String;
  begin
    p := tvMain.GetNodeData(Node);
    if (p<>nil) and (FLangIDSource<>0) and (FLangIDTran<>0) and (FLangIDSource<>FLangIDTran) then
      case p.Kind of
        nkProp:
          if dklptsUntranslated in p.pTranProp.States then begin
            s := FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcProp.sValue)];
            if s<>'' then begin
              p.pTranProp.sValue := s;
              Exclude(p.pTranProp.States, dklptsUntranslated);
              Modified := True;
            end;
          end;
        nkConst:
          if dklcsUntranslated in p.pTranConst.States then begin
            s := FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcConst.sDefValue)];
            if s<>'' then begin
              p.pTranConst.sDefValue := s;
              p.pTranConst.sValue    := s;
              Exclude(p.pTranConst.States, dklcsUntranslated);
              Modified := True;
            end;
          end;
      end;
  end;

  procedure TfMain.tvMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
  begin
     // Paint untranslated values shaded
    if (Column=IColIdx_Translated) and IsNodeUntranslated(Node) then
      with TargetCanvas do begin
        Brush.Color := CBack_UntranslatedValue;
        FillRect(CellRect);
      end;
  end;

  procedure TfMain.tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
  const aColors: Array[TNodeKind] of TColor = (0, CBack_CompEntry, CBack_PropEntry, CBack_ConstsNode, CBack_ConstEntry);
  begin
     // Paint the background depending on node kind
    ItemColor   := aColors[GetNodeKind(Node)];
    EraseAction := eaColor;
  end;

  procedure TfMain.tvMainEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  begin
    UpdateCurEntry;
  end;

  procedure TfMain.tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
  begin
     // It is allowed to edit translated values only 
    Allowed := (GetNodeKind(Node) in [nkProp, nkConst]) and (Column=IColIdx_Translated);
  end;

  procedure TfMain.tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  begin
    UpdateCurEntry;
    EnableActions;
  end;

  procedure TfMain.tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    case Column of
      IColIdx_Name:
        case GetNodeKind(Node) of
          nkComp:   ImageIndex := iiNode_Comp;
          nkProp:   ImageIndex := iiNode_Prop;
          nkConsts: ImageIndex := iiNode_Consts;
          nkConst:  ImageIndex := iiNode_Const;
        end;
      IColIdx_Translated: if IsNodeUntranslated(Node) then ImageIndex := iiUntranslated;
    end;
  end;

  procedure TfMain.tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  var
    p: PNodeData;
    s: String;
  begin
    p := Sender.GetNodeData(Node);
    s := '';
    case TextType of
       // Normal text
      ttNormal:
        case p.Kind of
          nkComp: if Column=IColIdx_Name then s := p.CompSource.CompName;
          nkProp:
            case Column of
              IColIdx_Name:       s := p.pSrcProp.sPropName;
              IColIdx_ID:         s := IntToStr(p.pSrcProp.iID);
              IColIdx_Original: begin
                if p.pDisplProp=nil then s := p.pSrcProp.sValue else s := p.pDisplProp.sValue;
                s := MultilineToLine(s);
              end;
              IColIdx_Translated: s := MultilineToLine(p.pTranProp.sValue);
            end;
          nkConsts: if Column=IColIdx_Name then s := SNode_Constants;
          nkConst:
            case Column of
              IColIdx_Name:       s := p.pSrcConst.sName;
              IColIdx_Original: begin
                if p.pDisplConst=nil then s := p.pSrcConst.sDefValue else s := p.pDisplConst.sDefValue;
                s := MultilineToLine(s);
              end;
              IColIdx_Translated: s := MultilineToLine(p.pTranConst.sDefValue);
            end;
        end;
       // Static text
      ttStatic: if (Column=IColIdx_Name) and (p.Kind in [nkComp, nkConsts]) then s := Format('(%d)', [Sender.ChildCount[Node]]);
    end;
    CellText := AnsiToUnicodeCP(s, cTreeCodePage);
  end;

  procedure TfMain.tvMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  var p, pParent: PNodeData;

     // Determines node kind for a root node
    function GetRootNodeKind(Node: PVirtualNode): TNodeKind;
    begin
      if Integer(Node.Index)<FLangSource.ComponentSources.Count then Result := nkComp else Result := nkConsts;
    end;

  begin
     // Get pointer to node's data
    p := Sender.GetNodeData(Node);
    if ParentNode<>nil then pParent := Sender.GetNodeData(ParentNode) else pParent := nil;
     // Determine node kind
    if ParentNode=nil then                          p.Kind := GetRootNodeKind(Node)
    else if GetRootNodeKind(ParentNode)=nkComp then p.Kind := nkProp
    else                                            p.Kind := nkConst;
     // Initialize node data (bind the node with corresponding objects) and chil count
    case p.Kind of
      nkComp: begin
        p.CompSource  := FLangSource.ComponentSources[Node.Index];
        if FDisplayTranslations<>nil then
          p.DisplComp := FDisplayTranslations.FindComponentName(p.CompSource.CompName);
        p.TranComp    := FTranslations.FindComponentName(p.CompSource.CompName);
        Sender.ChildCount[Node] := p.CompSource.PropertySources.Count;
      end;
      nkProp: begin
        p.pSrcProp     := pParent.CompSource.PropertySources[Node.Index];
        if (FDisplayTranslations<>nil) and (pParent.DisplComp<>nil) then
          p.pDisplProp := pParent.DisplComp.FindPropByID(p.pSrcProp.iID);
        p.pTranProp    := pParent.TranComp.FindPropByID(p.pSrcProp.iID);
      end;
      nkConsts: Sender.ChildCount[Node] := FLangSource.Constants.Count;
      nkConst: begin
        p.pSrcConst     := FLangSource.Constants[Node.Index];
        if FDisplayTranslations<>nil then
          p.pDisplConst := FDisplayTranslations.Constants.FindConstName(p.pSrcConst.sName);
        p.pTranConst    := FTranslations.Constants.FindConstName(p.pSrcConst.sName);
      end;
    end;
     // Expand the whole tree
    Include(InitialStates, ivsExpanded);
  end;

  procedure TfMain.tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
  begin
     // On Enter start editing
    if (Shift=[]) and (CharCode=VK_RETURN) and not Sender.IsEditing then begin
      DoDefault := False;
      with Sender do
        if FocusedNode<>nil then EditNode(FocusedNode, IColIdx_Translated);
    end;
  end;

  procedure TfMain.tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
  var
    p: PNodeData;
    s: String;
  begin
    s := UnicodeToAnsiCP(NewText, cTreeCodePage);
    p := Sender.GetNodeData(Node);
    case p.Kind of
      nkProp:
        with p.pTranProp^ do begin
          sValue := s;
          Exclude(States, dklptsUntranslated);
        end;
      nkConst:
        with p.pTranConst^ do begin
          sValue    := s;
          sDefValue := sValue;
          Exclude(States, dklcsUntranslated);
        end;
      else Exit;
    end;
    Modified := True;
     // If autoadding to repository is on, register the current translation
    if bSetting_ReposAutoAdd then AddNodeTranslationToRepository(Node); 
    UpdateStatusBar;
  end;

  procedure TfMain.tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  begin
     // Draw root nodes, and untranslated entries, in bold
    if (TextType=ttNormal) and ((Sender.NodeParent[Node]=nil) or ((Column=IColIdx_Translated) and IsNodeUntranslated(Node))) then
      TargetCanvas.Font.Style := [fsBold];
  end;

  procedure TfMain.UpdateCaption;
  const asMod: Array[Boolean] of String[1] = ('', '*');
  begin
    Caption := Format('[%s%s] - %s', [ExtractFileName(DisplayTranFileName), asMod[Modified], SAppCaption]);
    Application.Title := Caption;
  end;

  procedure TfMain.UpdateCurEntry;
  var
    p: PNodeData;
    sSrc, sTran: String;
    bEnable: Boolean;
  begin
    sSrc  := '';
    sTran := '';
    bEnable := False;
    p := tvMain.GetNodeData(tvMain.FocusedNode);
    if p<>nil then begin
      bEnable := p.Kind in [nkProp, nkConst];
      case p.Kind of
        nkProp: begin
          sSrc  := p.pSrcProp.sValue;
          sTran := p.pTranProp.sValue;
        end;
        nkConst: begin
          sSrc  := p.pSrcConst.sDefValue;
          sTran := p.pTranConst.sDefValue;
        end;
      end;
    end;
     // Update curent entry editors
    FUpdatingCurEntryEditor := True;
    try
      mCurSrcEntry.Text  := LineToMultiline(sSrc);
      mCurTranEntry.Text := LineToMultiline(sTran);
      EnableWndCtl(mCurSrcEntry,  bEnable);
      EnableWndCtl(mCurTranEntry, bEnable);
    finally
      FUpdatingCurEntryEditor := False;
    end;
  end;

  procedure TfMain.UpdateStatusBar;
  var
    n: PVirtualNode;
    iCntComp, iCntProp, iCntPropUntr, iCntConst, iCntConstUntr: Integer;
    p: PNodeData;
  begin
     // Reset counters
    iCntComp      := 0;
    iCntProp      := 0;
    iCntPropUntr  := 0;
    iCntConst     := 0;
    iCntConstUntr := 0;
     // Gather statistical info
    if FLangSource<>nil then begin
      n := tvMain.GetFirst;
      while n<>nil do begin
        p := tvMain.GetNodeData(n);
        case p.Kind of
          nkComp: Inc(iCntComp);
          nkProp: begin
            Inc(iCntProp);
            if dklptsUntranslated in p.pTranProp.States then Inc(iCntPropUntr);
          end;
          nkConst: begin
            Inc(iCntConst);
            if dklcsUntranslated in p.pTranConst.States then Inc(iCntConstUntr);
          end;
        end;
        n := tvMain.GetNext(n);
      end;
    end;
     // Update status bar
    with sbarMain.Panels do begin
      Items[ISBPanelIdx_CompCount].Caption      := Format(SStatusBar_CompCount,      [iCntComp]);
      Items[ISBPanelIdx_PropCount].Caption      := Format(SStatusBar_PropCount,      [iCntProp, iCntPropUntr]);
      Items[ISBPanelIdx_ConstCount].Caption     := Format(SStatusBar_ConstCount,     [iCntConst, iCntConstUntr]);
      Items[ISBPanelIdx_ReposTermCount].Caption := Format(SStatusBar_ReposTermCount, [FRepository.TermCount]);
    end;
  end;

  procedure TfMain.UpdateTree;
  var
    iRootCount: Integer;
    bOpen, bFirstShow: Boolean;
  begin
    bOpen := FLangSource<>nil;
    bFirstShow := bOpen and not tvMain.Visible;
     // Reload the tree
    tvMain.BeginUpdate;
    try
      tvMain.Clear;
      if bOpen then begin
         // Number of root nodes equals to number of components
        iRootCount := FLangSource.ComponentSources.Count;
         // Plus 1 if constants present
        if FLangSource.Constants.Count>0 then Inc(iRootCount);
        tvMain.RootNodeCount := iRootCount;
         // Reinit whole tree
        tvMain.ReinitChildren(nil, True);
      end;
    finally
      tvMain.EndUpdate;
    end;
     // If the tree is shown the first time, adjust column widths
    if bFirstShow then AdjustVTColumnWidth;
    tvMain.Visible := bOpen;
    if bOpen then begin
      ActivateVTNode(tvMain, tvMain.GetFirst, True, False);
      tvMain.SetFocus;
    end;
     // Update info
    UpdateCurEntry;
    UpdateStatusBar;
    EnableActions;
  end;

end.
