//**********************************************************************************************************************
//  $Id: Main.pas,v 1.15 2004-11-12 19:17:36 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
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
    aAddToRepository: TAction;
    aAutoTranslate: TAction;
    aClose: TAction;
    aExit: TAction;
    aFind: TAction;
    aHelpCheckUpdates: TAction;
    aHelpProductWebsite: TAction;
    aHelpSupport: TAction;
    aHelpVendorWebsite: TAction;
    aJumpNextUntranslated: TAction;
    aJumpPrevUntranslated: TAction;
    alMain: TActionList;
    aNewOrOpen: TAction;
    aNextEntry: TAction;
    aPrevEntry: TAction;
    aSave: TAction;
    aSaveAs: TAction;
    aSettings: TAction;
    aToggleFocus: TAction;
    aTranProps: TAction;
    bAbout: TTBXItem;
    bExit: TTBXItem;
    bJumpNextUntranslated: TTBXItem;
    bJumpPrevUntranslated: TTBXItem;
    bNewOrOpen: TTBXItem;
    bSave: TTBXItem;
    bSaveAs: TTBXItem;
    bSettings: TTBXItem;
    bTranProps: TTBXItem;
    cbEntryStateAutotranslated: TTBXCheckBox;
    cbEntryStateUntranslated: TTBXCheckBox;
    dkBottom: TTBXDock;
    dklcMain: TDKLanguageController;
    dkLeft: TTBXDock;
    dkRight: TTBXDock;
    dkTop: TTBXDock;
    dpCurSrcEntry: TTBXDockablePanel;
    dpCurTranEntry: TTBXDockablePanel;
    dpEntryProps: TTBXDockablePanel;
    fpMain: TFormPlacement;
    iAbout: TTBXItem;
    iAddToRepository: TTBXItem;
    iAutoTranslate: TTBXItem;
    iClose: TTBXItem;
    iExit: TTBXItem;
    iFileSep: TTBXSeparatorItem;
    iHelpCheckUpdates: TTBXItem;
    iHelpProductWebsite: TTBXItem;
    iHelpSupport: TTBXItem;
    iHelpVendorWebsite: TTBXItem;
    iJumpNextUntranslated: TTBXItem;
    iJumpPrevUntranslated: TTBXItem;
    ilMain: TTBImageList;
    iNewOrOpen: TTBXItem;
    iNextEntry: TTBXItem;
    ipmJumpNextUntranslated: TTBXItem;
    ipmJumpPrevUntranslated: TTBXItem;
    ipmNextEntry: TTBXItem;
    ipmPrevEntry: TTBXItem;
    ipmTranProps: TTBXItem;
    ipmTreeSep: TTBXSeparatorItem;
    iPrevEntry: TTBXItem;
    iSave: TTBXItem;
    iSaveAs: TTBXItem;
    iSettings: TTBXItem;
    iToggleCurSrcEntry: TTBXVisibilityToggleItem;
    iToggleCurTranEntry: TTBXVisibilityToggleItem;
    iToggleEntryProps: TTBXVisibilityToggleItem;
    iToggleFocus: TTBXItem;
    iToggleStatusBar: TTBXVisibilityToggleItem;
    iToggleToolbar: TTBXVisibilityToggleItem;
    iToolsSep: TTBXSeparatorItem;
    iTranProps: TTBXItem;
    iViewSep1: TTBXSeparatorItem;
    iViewSep2: TTBXSeparatorItem;
    lEntryStates: TTBXLabel;
    mCurSrcEntry: TMemo;
    mCurTranEntry: TMemo;
    mdkBottom: TTBXMultiDock;
    mdkLeft: TTBXMultiDock;
    mdkRight: TTBXMultiDock;
    mdkTop: TTBXMultiDock;
    MRUDisplay: TTBMRUList;
    MRUSource: TTBMRUList;
    MRUTran: TTBMRUList;
    pMain: TPanel;
    pmTree: TTBXPopupMenu;
    pmView: TTBXPopupMenu;
    sbarMain: TTBXStatusBar;
    smEdit: TTBXSubmenuItem;
    smFile: TTBXSubmenuItem;
    smHelp: TTBXSubmenuItem;
    smHelpInternet: TTBXSubmenuItem;
    smLanguage: TTBXSubmenuItem;
    smTools: TTBXSubmenuItem;
    smView: TTBXSubmenuItem;
    tbMain: TTBXToolbar;
    tbMenu: TTBXToolbar;
    tbSep1: TTBXSeparatorItem;
    tbSep2: TTBXSeparatorItem;
    tvMain: TVirtualStringTree;
    iFind: TTBXItem;
    bFind: TTBXItem;
    aFindNext: TAction;
    iFindNext: TTBXItem;
    bFindNext: TTBXItem;
    procedure aaAbout(Sender: TObject);
    procedure aaAddToRepository(Sender: TObject);
    procedure aaAutoTranslate(Sender: TObject);
    procedure aaClose(Sender: TObject);
    procedure aaExit(Sender: TObject);
    procedure aaFind(Sender: TObject);
    procedure aaHelpCheckUpdates(Sender: TObject);
    procedure aaHelpProductWebsite(Sender: TObject);
    procedure aaHelpSupport(Sender: TObject);
    procedure aaHelpVendorWebsite(Sender: TObject);
    procedure aaJumpNextUntranslated(Sender: TObject);
    procedure aaJumpPrevUntranslated(Sender: TObject);
    procedure aaNewOrOpen(Sender: TObject);
    procedure aaNextEntry(Sender: TObject);
    procedure aaPrevEntry(Sender: TObject);
    procedure aaSave(Sender: TObject);
    procedure aaSaveAs(Sender: TObject);
    procedure aaSettings(Sender: TObject);
    procedure aaToggleFocus(Sender: TObject);
    procedure aaTranProps(Sender: TObject);
    procedure cbEntryStateAutotranslatedChange(Sender: TObject);
    procedure cbEntryStateUntranslatedChange(Sender: TObject);
    procedure dklcMainLanguageChanged(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fpMainRestorePlacement(Sender: TObject);
    procedure fpMainSavePlacement(Sender: TObject);
    procedure mCurTranEntryChange(Sender: TObject);
    procedure tvMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvMainChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvMainEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure aaFindNext(Sender: TObject);
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
     // Update entry properties flag
    FUpdatingEntryProps: Boolean;
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
     // Returns translation states of a node
    function  GetNodeTranStates(Node: PVirtualNode): TDKLang_TranslationStates;
     // Tries to locate the next (bNext=True) or previous (bNext=False) untranslated node
    procedure LocateUntranslatedNode(bNext: Boolean);
     // Initially adjusts the VT column widths
    procedure AdjustVTColumnWidth;
     // App events
    procedure AppHint(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
     // Applies current setting
    procedure ApplySettings;
     // Initializes language items
    procedure InitLanguages;
     // Language item click event
    procedure LangItemClick(Sender: TObject);
     // Updates selection mark at language items
    procedure UpdateLangItems;
     // Updates status bar info
    procedure UpdateStatusBar;
     // Updates the entry properties info
    procedure UpdateEntryProps;
     // Changes selected entry translation states
    procedure ChangeSelEntryStates(AddStates, RemoveStates: TDKLang_TranslationStates);
     // Adds translation for Node to translation repository, if possible
    procedure AddNodeTranslationToRepository(Node: PVirtualNode);
     // Translates the Node by using translation repository, if possible
    procedure TranslateNodeFromRepository(Node: PVirtualNode);
     // Translates all nodes (bSelectedOnly=False) or just selected ones (bSelectedOnly=True)
    procedure TranslateAllNodes(bSelectedOnly: Boolean);
     // Searching function (also a callback for ShowFindDialog())
    function  Find(var Params: TSearchParams): Boolean;
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
uses Registry, ShellAPI, udSettings, udAbout, udOpenFiles, udDiffLog, udTranProps,
  udFind, StrUtils;

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
  begin
    TranslateAllNodes(True);
  end;

  procedure TfMain.aaClose(Sender: TObject);
  begin
    CloseProject(True);
  end;

  procedure TfMain.aaExit(Sender: TObject);
  begin
    Close;
  end;

  procedure TfMain.aaFind(Sender: TObject);
  begin
    ShowFindDialog(Find);
  end;

  procedure TfMain.aaFindNext(Sender: TObject);
  var SParams: TSearchParams;
  begin
    SParams := SearchParams;
    SParams.Flags := SParams.Flags-[sfReplace];
    Find(SParams); 
  end;

  procedure TfMain.aaHelpCheckUpdates(Sender: TObject);
  begin
    DKWeb.Open_VerCheck;
  end;

  procedure TfMain.aaHelpProductWebsite(Sender: TObject);
  begin
    DKWeb.Open_ViewInfo;
  end;

  procedure TfMain.aaHelpSupport(Sender: TObject);
  begin
    DKWeb.Open_Support;
  end;

  procedure TfMain.aaHelpVendorWebsite(Sender: TObject);
  begin
    DKWeb.Open_Index;
  end;

  procedure TfMain.aaJumpNextUntranslated(Sender: TObject);
  begin
    LocateUntranslatedNode(True);
  end;

  procedure TfMain.aaJumpPrevUntranslated(Sender: TObject);
  begin
    LocateUntranslatedNode(False);
  end;

  procedure TfMain.aaNewOrOpen(Sender: TObject);
  begin
    OpenFiles(FSourceFileName, FDisplayFileName, FTranFileName);
  end;

  procedure TfMain.aaNextEntry(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetNext(tvMain.FocusedNode);
    if n<>nil then ActivateVTNode(tvMain, n, True, True);
  end;

  procedure TfMain.aaPrevEntry(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetPrevious(tvMain.FocusedNode);
    if n<>nil then ActivateVTNode(tvMain, n, True, True);
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
        Filter     := ConstVal('STranFileFilter');
        Options    := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
        Title      := ConstVal('SDlgTitle_SaveTranFileAs');
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

  procedure TfMain.aaToggleFocus(Sender: TObject);
  begin
    if tvMain.Focused then begin
      if mCurTranEntry.CanFocus then mCurTranEntry.SetFocus;
    end else
      if tvMain.CanFocus then tvMain.SetFocus;
  end;

  procedure TfMain.aaTranProps(Sender: TObject);
  begin
    if EditTranslationProps(FTranslations, FLangIDSource, FLangIDTran) then Modified := True;
  end;

  procedure TfMain.AddNodeTranslationToRepository(Node: PVirtualNode);
  var p: PNodeData;
  begin
    p := tvMain.GetNodeData(Node);
    if (p<>nil) and (FLangIDSource<>0) and (FLangIDTran<>0) and (FLangIDSource<>FLangIDTran) then
      case p.Kind of
        nkProp: if not (dktsUntranslated in p.pTranProp.TranStates) then
          FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcProp.sValue)]     := ReposFixPrefixChar(p.pTranProp.sValue);
        nkConst: if not (dktsUntranslated in p.pTranConst.TranStates) then
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
      OpenFiles(sSrcFile, sDisplFile, sTranFile);
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

  procedure TfMain.cbEntryStateAutotranslatedChange(Sender: TObject);
  begin
    if FUpdatingEntryProps then Exit;
    if cbEntryStateAutotranslated.Checked then
      ChangeSelEntryStates([dktsAutotranslated], [])
    else
      ChangeSelEntryStates([], [dktsAutotranslated]);
  end;

  procedure TfMain.cbEntryStateUntranslatedChange(Sender: TObject);
  begin
    if FUpdatingEntryProps then Exit;
    if cbEntryStateUntranslated.Checked then
      ChangeSelEntryStates([dktsUntranslated], [])
    else
      ChangeSelEntryStates([], [dktsUntranslated]);
  end;

  procedure TfMain.ChangeSelEntryStates(AddStates, RemoveStates: TDKLang_TranslationStates);
  var
    n: PVirtualNode;
    p: PNodeData;
  begin
     // Iterate through the selected nodes
    n := tvMain.GetFirstSelected;
    while n<>nil do begin
      p := tvMain.GetNodeData(n);
      case p.Kind of
        nkProp:  with p.pTranProp^  do TranStates := TranStates+AddStates-RemoveStates;
        nkConst: with p.pTranConst^ do TranStates := TranStates+AddStates-RemoveStates;
      end;
      n := tvMain.GetNextSelected(n);
    end;
    tvMain.Invalidate;
    UpdateStatusBar;
  end;

  function TfMain.CheckSave: Boolean;
  begin
    Result := not Modified;
    if not Result then
      case MessageBox(Handle, PChar(Format(ConstVal('SConfirm_FileNotSaved'), [DisplayTranFileName])), PChar(ConstVal('SDlgTitle_Confirm')), MB_ICONEXCLAMATION or MB_YESNOCANCEL) of
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

  procedure TfMain.dklcMainLanguageChanged(Sender: TObject);
  begin
    UpdateLangItems;
  end;

  procedure TfMain.DoLoad(const sLangSrcFileName, sDisplayFileName, sTranFileName: String);
  var
    sDiff: String;
    iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer;
    bAutoTranslate: Boolean;
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
      sDiff := FLangSource.CompareStructureWith(
        FTranslations,
        iCntAddedComps, iCntAddedProps, iCntAddedConsts,
        iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts,
        iCntComps, iCntProps, iCntConsts);
       // Update the properties
      FModified        := False;
      FSourceFileName  := sLangSrcFileName;
      FDisplayFileName := sDisplayFileName;
      FTranFileName    := sTranFileName;
      MRUSource.Add(FSourceFileName);
      MRUDisplay.Add(FDisplayFileName);
      if FTranFileName<>'' then MRUTran.Add(FTranFileName);
      UpdateCaption;
       // Show the differences unless this is a new translation
      bAutoTranslate := False; 
      if (sTranFileName<>'') and (sDiff<>'') then ShowDiffLog(sDiff, iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts, bAutoTranslate);
       // Reload the tree
      UpdateTree;
    except
       // Destroy the objects in a case of failure
      CloseProject(True);
      raise;
    end;
     // If no languages specified or source and target languages are the same, show translation properties dialog
    if (FLangIDSource=0) or (FLangIDTran=0) or (FLangIDSource=FLangIDTran) then aTranProps.Execute;
     // Autotranslate entries if needed
    if bAutoTranslate then TranslateAllNodes(False); 
  end;

  procedure TfMain.DoSave(const sFileName: String);
  begin
     // Update translation parameter values
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_SourceLangID] := IntToStr(FLangIDSource);
      Values[SDKLang_TranParam_LangID]       := IntToStr(FLangIDTran);
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

  procedure TfMain.EnableActions;
  var bOpenFiles, bFocusedNode, bSelection: Boolean;
  begin
    bOpenFiles   := FLangSource<>nil;
    bFocusedNode := bOpenFiles and (tvMain.FocusedNode<>nil);
    bSelection   := bOpenFiles and (tvMain.SelectedCount>0);
     // File
    aSave.Enabled                      := bOpenFiles;
    aSaveAs.Enabled                    := bOpenFiles;
    aClose.Enabled                     := bOpenFiles;
     // Edit
    aFind.Enabled                      := bOpenFiles;
    aFindNext.Enabled                  := bOpenFiles and (sfSearchMade in SearchParams.Flags);
    aTranProps.Enabled                 := bOpenFiles;
     // View                           
    aPrevEntry.Enabled                 := bFocusedNode;
    aNextEntry.Enabled                 := bFocusedNode;
    aJumpPrevUntranslated.Enabled      := bOpenFiles;
    aJumpNextUntranslated.Enabled      := bOpenFiles;
     // Tools                          
    aAddToRepository.Enabled           := bSelection;
    aAutoTranslate.Enabled             := bSelection;
     // Misc
    cbEntryStateUntranslated.Enabled   := bSelection;
    cbEntryStateAutotranslated.Enabled := bSelection;
  end;

  function TfMain.Find(var Params: TSearchParams): Boolean;
  var
    n: PVirtualNode;
    sSearch: String;
    iPatLen, iMatchCount, iReplacedCount: Integer;
    pData: PNodeData;
    bMatches: Boolean;

    function GetLastSelected: PVirtualNode;
    begin
      Result := tvMain.GetLast;
      while (Result<>nil) and not (vsSelected in Result.States) do Result := tvMain.GetPrevious(Result);
    end;

    function GetPreviousSelected(Node: PVirtualNode): PVirtualNode;
    begin
      Result := Node;
      repeat
        Result := tvMain.GetPrevious(Result);
        if Result=nil then Break
        else if vsSelected in Result.States then Exit;
      until False;
    end;

    function Matches(const s: String): Boolean;
    const NoWordChars = [#0..'/', ':'..'@', '['..'`', '{'..#137, '«', '»'];
    var iPos: Integer;
    begin
      if sfCaseSensitive in Params.Flags then iPos := AnsiPos(sSearch, s) else iPos := AnsiPos(sSearch, AnsiUpperCase(s));
      Result := iPos>0;
       // If whole words are accepted only
      if Result and (sfWholeWordsOnly in Params.Flags) then
        Result := ((iPos=1) or (s[iPos-1] in NoWordChars)) and ((iPos>Length(s)-iPatLen) or (s[iPos+iPatLen] in NoWordChars));
    end;

  begin
     // Prepare the pattern
    sSearch := Params.sSearchPattern;
    if not (sfCaseSensitive in Params.Flags) then sSearch := AnsiUpperCase(sSearch);
    iPatLen := Length(sSearch);
     // Determine the start of the search
    n := tvMain.FocusedNode;
     // -- Restart search
    if (n=nil) or
       (sfEntireScope in Params.Flags) or
       ((sfSelectedOnly in Params.Flags) and not (vsSelected in n.States)) then
       // -- Search selection only
      if sfSelectedOnly in Params.Flags then
        if sfBackward in Params.Flags then n := GetLastSelected else n := tvMain.GetFirstSelected
       // -- Search all nodes
      else
        if sfBackward in Params.Flags then n := tvMain.GetLast else n := tvMain.GetFirst
     // -- Continue search
    else
      if sfBackward in Params.Flags then n := tvMain.GetPrevious(n) else n := tvMain.GetNext(n);
     // Search through the nodes
    iMatchCount    := 0;
    iReplacedCount := 0;
    while n<>nil do begin
      pData := tvMain.GetNodeData(n);
      bMatches := False;
       // We do not search anything but translated value in Replace mode
      if not (sfReplace in Params.Flags) then begin
         // Test Name
        if not bMatches and (sfSearchNames in Params.Flags) then
          case pData.Kind of
            nkComp:  bMatches := Matches(pData.CompSource.CompName);
            nkProp:  bMatches := Matches(pData.pSrcProp.sPropName);
            nkConst: bMatches := Matches(pData.pSrcConst.sName);
          end;
         // Test Original Value
        if not bMatches and (sfSearchOriginal in Params.Flags) then
          case pData.Kind of
            nkProp:  if pData.pDisplProp=nil  then bMatches := Matches(pData.pSrcProp.sValue)     else bMatches := Matches(pData.pDisplProp.sValue);
            nkConst: if pData.pDisplConst=nil then bMatches := Matches(pData.pSrcConst.sDefValue) else bMatches := Matches(pData.pDisplConst.sDefValue);
          end;
      end;
       // Finally, test Translated Value
      if not bMatches and (sfSearchTranslated in Params.Flags) then
        case pData.Kind of
          nkProp:  bMatches := Matches(pData.pTranProp.sValue);
          nkConst: bMatches := Matches(pData.pTranConst.sDefValue);
        end;
       // Found the match?
      if bMatches then begin
        Inc(iMatchCount);
        ActivateVTNode(tvMain, n, True, False);
         // If Replace mode
        if sfReplace in Params.Flags then begin
          //!!! write replace code

          Inc(iReplacedCount);
        end;
         // If this isn't 'Replace all' call, then exit after a match has been successfully located
        if Params.Flags*[sfReplace, sfReplaceAll]<>[sfReplace, sfReplaceAll] then Break;
      end;
       // Advance to the next/previous node
      if sfSelectedOnly in Params.Flags then
        if sfBackward in Params.Flags then n := GetPreviousSelected(n) else n := tvMain.GetNextSelected(n)
      else
        if sfBackward in Params.Flags then n := tvMain.GetPrevious(n) else n := tvMain.GetNext(n);
    end;
     // Update actions
    Include(Params.Flags, sfSearchMade);
    EnableActions;
     // Inform the user about results
    Result := iMatchCount>0;
    if not Result then
      Info(ConstVal('SMsg_NoSearchResults', [Params.sSearchPattern]))
    else if Params.Flags*[sfReplace, sfReplaceAll]=[sfReplace, sfReplaceAll] then
      Info(ConstVal('SMsg_ReplacedInfo', [iReplacedCount, Params.sSearchPattern]));
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
     // Initialize language items
    InitLanguages; 
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
    TBRegLoadPositions(Self, HKEY_CURRENT_USER, SRegKey_Toolbars);
     // Restore MRUs
    MRUSource.LoadFromRegIni (rif, SRegSection_MRUSource);
    MRUDisplay.LoadFromRegIni(rif, SRegSection_MRUDisplay);
    MRUTran.LoadFromRegIni   (rif, SRegSection_MRUTranslation);
     // Load settings
    LangManager.LanguageID     := rif.ReadInteger(SRegSection_Preferences, 'Language',          ILangID_USEnglish);
    sbarMain.Visible           := rif.ReadBool   (SRegSection_Preferences, 'StatusBarVisible',  True);
    sSetting_InterfaceFont     := rif.ReadString (SRegSection_Preferences, 'InterfaceFont',     FontToStr(Font));
    sSetting_TableFont         := rif.ReadString (SRegSection_Preferences, 'TableFont',         sSetting_InterfaceFont);
    sSetting_RepositoryDir     := rif.ReadString (SRegSection_Preferences, 'RepositoryPath',    ExtractFileDir(ParamStr(0)));
    bSetting_ReposRemovePrefix := rif.ReadBool   (SRegSection_Preferences, 'ReposRemovePrefix', True);
    bSetting_ReposAutoAdd      := rif.ReadBool   (SRegSection_Preferences, 'ReposAutoAdd',      True);
     // Load the repository
    FRepository.LoadFromFile(IncludeTrailingPathDelimiter(sSetting_RepositoryDir)+SRepositoryFileName);
     // Apply loaded settings
    ApplySettings;
    UpdateLangItems;
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
    rif.WriteInteger(SRegSection_Preferences, 'Language',          LangManager.LanguageID);
    rif.WriteBool   (SRegSection_Preferences, 'StatusBarVisible',  sbarMain.Visible);
    rif.WriteString (SRegSection_Preferences, 'InterfaceFont',     sSetting_InterfaceFont);
    rif.WriteString (SRegSection_Preferences, 'TableFont',         sSetting_TableFont);
    rif.WriteString (SRegSection_Preferences, 'RepositoryPath',    sSetting_RepositoryDir);
    rif.WriteBool   (SRegSection_Preferences, 'ReposRemovePrefix', bSetting_ReposRemovePrefix);
    rif.WriteBool   (SRegSection_Preferences, 'ReposAutoAdd',      bSetting_ReposAutoAdd);
     // Save the repository
    FRepository.SaveToFile(IncludeTrailingPathDelimiter(sSetting_RepositoryDir)+SRepositoryFileName);
  end;

  function TfMain.GetDisplayTranFileName: String;
  begin
    Result := iif(FTranFileName='', STranFileDefaultName, FTranFileName);
  end;

  function TfMain.GetNodeKind(Node: PVirtualNode): TNodeKind;
  begin
    if Node=nil then Result := nkNone else Result := PNodeData(tvMain.GetNodeData(Node)).Kind;
  end;

  function TfMain.GetNodeTranStates(Node: PVirtualNode): TDKLang_TranslationStates;
  var p: PNodeData;
  begin
    p := tvMain.GetNodeData(Node);
    case p.Kind of
      nkProp:  Result := p.pTranProp.TranStates;
      nkConst: Result := p.pTranConst.TranStates;
      else     Result := [];
    end;
  end;

  procedure TfMain.InitLanguages;
  var
    i: Integer;
    tbi: TTBCustomItem;
  begin
    smLanguage.Clear;
    for i := 0 to LangManager.LanguageCount-1 do begin
      tbi := TTBXItem.Create(Self);
      tbi.Caption := LangManager.LanguageNames[i];
      tbi.Tag     := LangManager.LanguageIDs[i];
      tbi.OnClick := LangItemClick;
      smLanguage.Add(tbi);
    end;
  end;

  procedure TfMain.LangItemClick(Sender: TObject);
  begin
    LangManager.LanguageID := TComponent(Sender).Tag;
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
      if GetNodeTranStates(Node)*[dktsUntranslated, dktsAutotranslated]<>[] then begin
        ActivateVTNode(tvMain, Node, True, True);
        Exit;
      end;
      if bNext then Node := tvMain.GetNext(Node) else Node := tvMain.GetPrevious(Node);
    end;
     // Beep if not found
    MessageBeep(MB_OK); 
  end;

  procedure TfMain.mCurTranEntryChange(Sender: TObject);
  begin
    if FUpdatingCurEntryEditor then Exit;
    tvMain.Text[tvMain.FocusedNode, IColIdx_Translated] := EncodeControlChars(mCurTranEntry.Text);
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

  procedure TfMain.TranslateAllNodes(bSelectedOnly: Boolean);
  var n: PVirtualNode;
  begin
    if bSelectedOnly then n := tvMain.GetFirstSelected else n := tvMain.GetFirst;
    while n<>nil do begin
      TranslateNodeFromRepository(n);
      if bSelectedOnly then n := tvMain.GetNextSelected(n) else n := tvMain.GetNext(n);
    end;
     // Update display
    tvMain.Invalidate;
    UpdateStatusBar;
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
          if dktsUntranslated in p.pTranProp.TranStates then begin
            s := FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcProp.sValue)];
            if s<>'' then begin
              with p.pTranProp^ do begin
                sValue     := s;
                TranStates := TranStates-[dktsUntranslated]+[dktsAutotranslated];
              end;
              Modified := True;
            end;
          end;
        nkConst:
          if dktsUntranslated in p.pTranConst.TranStates then begin
            s := FRepository.Translations[FLangIDSource, FLangIDTran, ReposFixPrefixChar(p.pSrcConst.sDefValue)];
            if s<>'' then begin
              with p.pTranConst^ do begin
                sDefValue  := s;
                sValue     := s;
                TranStates := TranStates-[dktsUntranslated]+[dktsAutotranslated];
              end;
              Modified := True;
            end;
          end;
      end;
  end;

  procedure TfMain.tvMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
  begin
     // Paint untranslated values shaded
    if (Column=IColIdx_Translated) and (dktsUntranslated in GetNodeTranStates(Node)) then
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

  procedure TfMain.tvMainChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  begin
    UpdateEntryProps;
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
      IColIdx_Translated: if dktsUntranslated in GetNodeTranStates(Node) then ImageIndex := iiUntranslated;
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
              IColIdx_Name: s := p.pSrcProp.sPropName;
              IColIdx_ID:   s := IntToStr(p.pSrcProp.iID);
              IColIdx_Original: begin
                if p.pDisplProp=nil then s := p.pSrcProp.sValue else s := p.pDisplProp.sValue;
                s := EncodeControlChars(s);
              end;
              IColIdx_Translated: s := EncodeControlChars(p.pTranProp.sValue);
            end;
          nkConsts: if Column=IColIdx_Name then s := ConstVal('SNode_Constants');
          nkConst:
            case Column of
              IColIdx_Name: s := p.pSrcConst.sName;
              IColIdx_Original: begin
                if p.pDisplConst=nil then s := p.pSrcConst.sDefValue else s := p.pDisplConst.sDefValue;
                s := EncodeControlChars(s);
              end;
              IColIdx_Translated: s := EncodeControlChars(p.pTranConst.sDefValue);
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
     // Initialize node data (bind the node with corresponding objects) and child count
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
          sValue := DecodeControlChars(s);
          TranStates := TranStates-[dktsUntranslated, dktsAutotranslated];
        end;
      nkConst:
        with p.pTranConst^ do begin
          sValue     := DecodeControlChars(s);
          sDefValue  := sValue;
          TranStates := TranStates-[dktsUntranslated, dktsAutotranslated];
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
     // Draw root nodes, and untranslated/autotranslated entries, in bold
    if (TextType=ttNormal) and
       ((Sender.NodeParent[Node]=nil) or
        ((Column=IColIdx_Translated) and (GetNodeTranStates(Node)*[dktsUntranslated, dktsAutotranslated]<>[]))) then
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
      mCurSrcEntry.Text  := sSrc;
      mCurTranEntry.Text := sTran;
      EnableWndCtl(mCurSrcEntry,  bEnable);
      EnableWndCtl(mCurTranEntry, bEnable);
    finally
      FUpdatingCurEntryEditor := False;
    end;
  end;

  procedure TfMain.UpdateEntryProps;
  type TFlagState = (fsUnknown, fsOff, fsOn, fsMixed);
  const aCBStates: Array[TFlagState] of TCheckBoxState = (cbUnchecked, cbUnchecked, cbChecked, cbGrayed);
  var
    StUntranslated, StAutotranslated: TFlagState;
    n: PVirtualNode;
    TS: TDKLang_TranslationStates;

     // Tests TS for a specified translation state and updates State appropriately
    procedure TestState(TranState: TDKLang_TranslationState; var State: TFlagState);
    begin
      case State of
        fsUnknown:   if TranState in TS then State := fsOn else State := fsOff;
        fsOff, fsOn: if (TranState in TS)<>(State=fsOn) then State := fsMixed;
      end;
    end;

  begin
    StUntranslated   := fsUnknown;
    StAutotranslated := fsUnknown;
     // Iterate through the selected nodes
    n := tvMain.GetFirstSelected;
    while n<>nil do begin
       // Get node translation states
      TS := GetNodeTranStates(n);
       // Update state vars
      if GetNodeKind(n) in [nkProp, nkConst] then begin
        TestState(dktsUntranslated,   StUntranslated);
        TestState(dktsAutotranslated, StAutotranslated);
      end;
      n := tvMain.GetNextSelected(n);
    end;
     // Apply the determined properties
    FUpdatingEntryProps := True;
    try
      cbEntryStateUntranslated.State   := aCBStates[StUntranslated];
      cbEntryStateAutotranslated.State := aCBStates[StAutotranslated];
    finally
      FUpdatingEntryProps := False;
    end;
  end;

  procedure TfMain.UpdateLangItems;
  var i: Integer;
  begin
    for i := 0 to smLanguage.Count-1 do
      with smLanguage[i] do
        Checked := Tag=LangManager.LanguageID;
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
            if dktsUntranslated in p.pTranProp.TranStates then Inc(iCntPropUntr);
          end;
          nkConst: begin
            Inc(iCntConst);
            if dktsUntranslated in p.pTranConst.TranStates then Inc(iCntConstUntr);
          end;
        end;
        n := tvMain.GetNext(n);
      end;
    end;
     // Update status bar
    with sbarMain.Panels do begin
      Items[ISBPanelIdx_CompCount].Caption       := Format(ConstVal('SStatusBar_CompCount'),       [iCntComp]);
      Items[ISBPanelIdx_PropCount].Caption       := Format(ConstVal('SStatusBar_PropCount'),       [iCntProp, iCntPropUntr]);
      Items[ISBPanelIdx_ConstCount].Caption      := Format(ConstVal('SStatusBar_ConstCount'),      [iCntConst, iCntConstUntr]);
      Items[ISBPanelIdx_ReposEntryCount].Caption := Format(ConstVal('SStatusBar_ReposEntryCount'), [FRepository.EntryCount]);
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
