//**********************************************************************************************************************
//  $Id: Main.pas,v 1.25 2006-08-28 18:48:20 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, XPMan, TntSystem, TntWindows,
  TntSysUtils, TntDialogs, TntForms, DKLang, ConsVars, uTranEdPlugin, 
  DKLTranEdFrm, Menus, TB2Item, TBX, TB2MRU, Placemnt, ImgList, ActnList,
  TntActnList, StdCtrls, TntStdCtrls, TBXDkPanels, VirtualTrees, ExtCtrls,
  TntExtCtrls, TBXStatusBars, TB2Dock, TB2Toolbar;

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

  TfMain = class(TDKLTranEdForm, IDKLang_TranEd_Application, ITranEdApplication)
    aAbout: TTntAction;
    aAddToRepository: TTntAction;
    aAutoTranslate: TTntAction;
    aBookmarkAdd: TTntAction;
    aBookmarkDelete: TTntAction;
    aBookmarkJump: TTntAction;
    aClose: TTntAction;
    aCopy: TTntAction;
    aCut: TTntAction;
    aExit: TTntAction;
    aFind: TTntAction;
    aFindNext: TTntAction;
    aHelp: TTntAction;
    aHelpCheckUpdates: TTntAction;
    aHelpProductWebsite: TTntAction;
    aHelpSupport: TTntAction;
    aHelpVendorWebsite: TTntAction;
    aJumpNextUntranslated: TTntAction;
    aJumpPrevUntranslated: TTntAction;
    alMain: TTntActionList;
    aNewOrOpen: TTntAction;
    aNextEntry: TTntAction;
    aPaste: TTntAction;
    aPrevEntry: TTntAction;
    aReplace: TTntAction;
    aSave: TTntAction;
    aSaveAs: TTntAction;
    aSettings: TTntAction;
    aToggleFocus: TTntAction;
    aTranProps: TTntAction;
    bAbout: TTBXItem;
    bBookmarkAdd: TTBXItem;
    bBookmarkDelete: TTBXItem;
    bBookmarkJump: TTBXItem;
    bCopy: TTBXItem;
    bCut: TTBXItem;
    bExit: TTBXItem;
    bFind: TTBXItem;
    bFindNext: TTBXItem;
    bJumpNextUntranslated: TTBXItem;
    bJumpPrevUntranslated: TTBXItem;
    bNewOrOpen: TTBXItem;
    bPaste: TTBXItem;
    bReplace: TTBXItem;
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
    dpBookmarks: TTBXDockablePanel;
    dpCurSrcEntry: TTBXDockablePanel;
    dpCurTranEntry: TTBXDockablePanel;
    dpEntryProps: TTBXDockablePanel;
    fpMain: TFormPlacement;
    giBookmarks: TTBGroupItem;
    giToolsPluginItems: TTBGroupItem;
    iAbout: TTBXItem;
    iAddToRepository: TTBXItem;
    iAutoTranslate: TTBXItem;
    iBookmarkAdd: TTBXItem;
    iBookmarkDelete: TTBXItem;
    iClose: TTBXItem;
    iCopy: TTBXItem;
    iCut: TTBXItem;
    iEditSepBookmarkAdd: TTBXSeparatorItem;
    iEditSepFind: TTBXSeparatorItem;
    iEditSepTranProps: TTBXSeparatorItem;
    iExit: TTBXItem;
    iFileSep: TTBXSeparatorItem;
    iFind: TTBXItem;
    iFindNext: TTBXItem;
    iHelp: TTBXItem;
    iHelpCheckUpdates: TTBXItem;
    iHelpProductWebsite: TTBXItem;
    iHelpSupport: TTBXItem;
    iHelpVendorWebsite: TTBXItem;
    iJumpNextUntranslated: TTBXItem;
    iJumpPrevUntranslated: TTBXItem;
    ilMain: TTBImageList;
    iNewOrOpen: TTBXItem;
    iNextEntry: TTBXItem;
    iPaste: TTBXItem;
    ipmCurSrcEntryCopy: TTBXItem;
    ipmCurTranEntryCopy: TTBXItem;
    ipmCurTranEntryCut: TTBXItem;
    ipmCurTranEntryPaste: TTBXItem;
    ipmJumpNextUntranslated: TTBXItem;
    ipmJumpPrevUntranslated: TTBXItem;
    ipmNextEntry: TTBXItem;
    ipmPrevEntry: TTBXItem;
    ipmTranProps: TTBXItem;
    ipmTreeBookmarkAdd: TTBXItem;
    ipmTreeCopy: TTBXItem;
    ipmTreeCut: TTBXItem;
    ipmTreePaste: TTBXItem;
    ipmTreeSep: TTBXSeparatorItem;
    ipmTreeSepBookmarkAdd: TTBXSeparatorItem;
    ipmTreeSepPrevEntry: TTBXSeparatorItem;
    iPrevEntry: TTBXItem;
    iReplace: TTBXItem;
    iSave: TTBXItem;
    iSaveAs: TTBXItem;
    iSepToolsPluginItems: TTBXSeparatorItem;
    iSettings: TTBXItem;
    iToggleBookmarks: TTBXVisibilityToggleItem;
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
    mCurSrcEntry: TTntMemo;
    mCurTranEntry: TTntMemo;
    mdkBottom: TTBXMultiDock;
    mdkLeft: TTBXMultiDock;
    mdkRight: TTBXMultiDock;
    mdkTop: TTBXMultiDock;
    MRUDisplay: TTBMRUList;
    MRUReplace: TTBMRUList;
    MRUSearch: TTBMRUList;
    MRUSource: TTBMRUList;
    MRUTran: TTBMRUList;
    pMain: TTntPanel;
    pmBookmarks: TTBXPopupMenu;
    pmCurSrcEntry: TTBXPopupMenu;
    pmCurTranEntry: TTBXPopupMenu;
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
    tbBookmarks: TTBXToolbar;
    tbMain: TTBXToolbar;
    tbMenu: TTBXToolbar;
    tbSep2: TTBXSeparatorItem;
    tbSepCut: TTBXSeparatorItem;
    tbSepFind: TTBXSeparatorItem;
    tbSepJumpPrevUntranslated: TTBXSeparatorItem;
    tbSepTranProps: TTBXSeparatorItem;
    tvBookmarks: TVirtualStringTree;
    tvMain: TVirtualStringTree;
    procedure aaAbout(Sender: TObject);
    procedure aaAddToRepository(Sender: TObject);
    procedure aaAutoTranslate(Sender: TObject);
    procedure aaBookmarkAdd(Sender: TObject);
    procedure aaBookmarkDelete(Sender: TObject);
    procedure aaBookmarkJump(Sender: TObject);
    procedure aaClose(Sender: TObject);
    procedure aaCopy(Sender: TObject);
    procedure aaCut(Sender: TObject);
    procedure aaExit(Sender: TObject);
    procedure aaFind(Sender: TObject);
    procedure aaFindNext(Sender: TObject);
    procedure aaHelpCheckUpdates(Sender: TObject);
    procedure aaHelpProductWebsite(Sender: TObject);
    procedure aaHelpSupport(Sender: TObject);
    procedure aaHelpVendorWebsite(Sender: TObject);
    procedure aaJumpNextUntranslated(Sender: TObject);
    procedure aaJumpPrevUntranslated(Sender: TObject);
    procedure aaNewOrOpen(Sender: TObject);
    procedure aaNextEntry(Sender: TObject);
    procedure aaPaste(Sender: TObject);
    procedure aaPrevEntry(Sender: TObject);
    procedure aaReplace(Sender: TObject);
    procedure aaSave(Sender: TObject);
    procedure aaSaveAs(Sender: TObject);
    procedure aaSettings(Sender: TObject);
    procedure aaToggleFocus(Sender: TObject);
    procedure aaTranProps(Sender: TObject);
    procedure cbEntryStateAutotranslatedChange(Sender: TObject);
    procedure cbEntryStateUntranslatedChange(Sender: TObject);
    procedure dklcMainLanguageChanged(Sender: TObject);
    procedure EnableActionsNotify(Sender: TObject);
    procedure fpMainRestorePlacement(Sender: TObject);
    procedure fpMainSavePlacement(Sender: TObject);
    procedure mCurTranEntryChange(Sender: TObject);
    procedure tvBookmarksChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvBookmarksGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvBookmarksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvBookmarksKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure tvMainAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure tvMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvMainChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvMainEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
     // Language source storage
    FLangSource: TLangSource;
     // Translations used for display; nil if no translation was open
    FDisplayTranslations: TDKLang_CompTranslations;
     // Loaded or new translations
    FTranslations: TDKLang_CompTranslations;
     // Source and target translation language
    FLangIDSource: LANGID;
    FLangIDTranslation: LANGID;
     // Flag that command line parameters have been checked
    FCmdLineChecked: Boolean;
     // True while updating tvMain from the Translated entry editor 
    FSettingTranTextFromEditor: Boolean;
     // True while destroying the form
    FIsDestroying: Boolean;
     // Update current entry editor flag
    FUpdatingCurEntryEditor: Boolean;
     // Update entry properties flag
    FUpdatingEntryProps: Boolean;
     // A search match node
    FSearchMatchNode: PVirtualNode;
     // Translation repository
    FRepository: TTranRepository;
     // A list of bookmarks
    FBookmarks: TStringList;
     // Plugin host
    FPluginHost: TPluginHost;
     // Prop storage
    FModified: Boolean;
    FTranslationFileName: WideString;
    FLanguageSourceFileName: WideString;
    FDisplayFileName: WideString;
     // Redisplays the language source tree
    procedure UpdateTree;
     // Updates current entry panel contents
    procedure UpdateCurEntry;
     // Checks whether translation file is modified and asks to save it
    function  CheckSave: Boolean;
     // Updates form caption
    procedure UpdateCaption;
     // Adjusts Actions availability
    procedure EnableActions;
     // Closes all files without any confirmation
    procedure DoCloseFiles;
     // Return the kind of Node
    function  GetNodeKind(Node: PVirtualNode): TNodeKind;
     // Returns translation states of a node
    function  GetNodeTranStates(Node: PVirtualNode): TDKLang_TranslationStates;
     // Copies Node's translated text into the clipboard if the text is not empty and returns True; otherwise returns
     //   False. Node may be nil
    function  CopyNodeTranslatedText(Node: PVirtualNode): Boolean;
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
     // Translates the Node by using the plugin, if possible. If Translator is nil, uses translation repository
    procedure TranslateNode(Node: PVirtualNode; Translator: IDKLang_TranEd_Translator);
     // Translates all nodes (bSelectedOnly=False) or just selected ones (bSelectedOnly=True)
    procedure TranslateAllNodes(bSelectedOnly: Boolean;  Translator: IDKLang_TranEd_Translator);
     // Searching function (also a callback for ShowFindDialog())
    function  Find(var Params: TSearchParams): Boolean;
     // Resets the search match node
    procedure ResetSearchMatch;
     // Updates the tvBookmarks
    procedure RefreshBookmarks;
     // If node focused in tvMain corresponds to a bookmark, highlights that node in tvBookmarks
    procedure UpdateCurBookmark;
     // IDKLang_TranEd_Application
    function  FilesClose: LongBool; stdcall;
    function  FilesOpen(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString): LongBool; stdcall;
    function  FilesSave(const wsFileName: WideString; bUnicode: LongBool): LongBool; stdcall;
    function  GetDisplayFileName: WideString; stdcall;
    function  GetIsFileOpen: LongBool; stdcall;
    function  GetIsModified: LongBool; stdcall;
    function  GetLangIDSource: LANGID; stdcall;
    function  GetLangIDTranslation: LANGID; stdcall;
    function  GetLanguageSourceFileName: WideString; stdcall;
    function  GetSelectedItemCount: Integer; stdcall;
    function  GetTranslationFileName: WideString; stdcall;
    procedure FilesLoad(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString); stdcall;
    procedure TranslateSelected(Translator: IDKLang_TranEd_Translator); stdcall;
     // ITranEdApplication
    procedure PluginLoaded(PluginEntry: TPluginEntry);
    procedure PluginUnloading(PluginEntry: TPluginEntry);
     // Message handlers
    procedure CMFocusChanged(var Msg: TMessage); message CM_FOCUSCHANGED;
     // Prop handlers
    function  GetDisplayTranFileName: WideString;
    procedure SetModified(Value: Boolean);
    procedure SetTranslationFileName(const Value: WideString);
  protected
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure DoShow; override;
  public
    function  CloseQuery: Boolean; override;
     // Props
     // -- Name of the file used for display-translation. Empty string if no such translation was open
    property DisplayFileName: WideString read FDisplayFileName;
     // -- Displayed name of translation file currently open
    property DisplayTranFileName: WideString read GetDisplayTranFileName;
     // -- True, if editor contents was saved since last save
    property Modified: Boolean read FModified write SetModified;
     // -- Name of the language source file currently open
    property LanguageSourceFileName: WideString read FLanguageSourceFileName;
     // -- Name of the translation file currently open
    property TranslationFileName: WideString read FTranslationFileName write SetTranslationFileName;
  end;

const
   // Image indexes corresponding to node kinds
  aiNodeKindImageIndexes: Array[TNodeKind] of Integer = (
    -1,            // nkNone
    iiNode_Comp,   // nkComp
    iiNode_Prop,   // nkProp
    iiNode_Consts, // nkConsts
    iiNode_Const); // nkConst

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses
  Registry, ShellAPI,
  TntClipbrd, 
  udSettings, udAbout, udOpenFiles, udDiffLog, udTranProps, udFind, StrUtils, udPromptReplace,
  ChmHlp;

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
    TranslateAllNodes(True, nil);
  end;

  procedure TfMain.aaBookmarkAdd(Sender: TObject);
  var
    n, nParent: PVirtualNode;
    sBookmarkText: String;
  begin
    n := tvMain.FocusedNode;
     // Add the current node to bookmarks if there is no one
    if (n<>nil) and (FBookmarks.IndexOfObject(Pointer(n))<0) then begin
       // Compile bookmark text
      sBookmarkText := tvMain.Text[n, IColIdx_Name];
      nParent := tvMain.NodeParent[n];
      if nParent<>nil then sBookmarkText := tvMain.Text[nParent, IColIdx_Name]+'.'+sBookmarkText;
       // Add the bookmark
      FBookmarks.AddObject(sBookmarkText, Pointer(n));
       // Refresh the node
      tvMain.Invalidate; 
       // Refresh the bookmark list
      RefreshBookmarks;
    end;
  end;

  procedure TfMain.aaBookmarkDelete(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvBookmarks.FocusedNode;
    if n<>nil then begin
      tvBookmarks.BeginUpdate;
      try
         // Remove the bookmark
        FBookmarks.Delete(n.Index);
         // Refresh the node
        tvMain.Invalidate;
         // Refresh the bookmark list
        RefreshBookmarks;
      finally
        tvBookmarks.EndUpdate;
      end;
    end;
  end;

  procedure TfMain.aaBookmarkJump(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvBookmarks.FocusedNode;
    if n<>nil then ActivateVTNode(tvMain, PVirtualNode(FBookmarks.Objects[n.Index]), True, True);
  end;

  procedure TfMain.aaClose(Sender: TObject);
  begin
    FilesClose;
  end;

  procedure TfMain.aaCopy(Sender: TObject);
  begin
    if ActiveControl is TCustomEdit then
      TCustomEdit(ActiveControl).CopyToClipboard
    else if ActiveControl=tvMain then
      CopyNodeTranslatedText(tvMain.FocusedNode);
  end;

  procedure TfMain.aaCut(Sender: TObject);
  var n: PVirtualNode;
  begin
    if ActiveControl is TCustomEdit then
      TCustomEdit(ActiveControl).CutToClipboard
    else if ActiveControl=tvMain then begin
      n := tvMain.FocusedNode;
      if CopyNodeTranslatedText(n) then begin
        ResetSearchMatch;
        tvMain.Text[n, IColIdx_Translated] := '';
      end;
    end;
  end;

  procedure TfMain.aaExit(Sender: TObject);
  begin
    Close;
  end;

  procedure TfMain.aaFind(Sender: TObject);
  begin
    Exclude(SearchParams.Flags, sfReplace);
    ShowFindDialog(Find, MRUSearch.Items, MRUReplace.Items);
  end;

  procedure TfMain.aaFindNext(Sender: TObject);
  var SParams: TSearchParams;
  begin
    SParams := SearchParams;
    SParams.Flags := SParams.Flags-[sfEntireScope, sfReplace];
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
    FilesOpen(FLanguageSourceFileName, FDisplayFileName, FTranslationFileName);
  end;

  procedure TfMain.aaNextEntry(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetNext(tvMain.FocusedNode);
    if n<>nil then ActivateVTNode(tvMain, n, True, True);
  end;

  procedure TfMain.aaPaste(Sender: TObject);
  var n: PVirtualNode;
  begin
    if TntClipboard.HasFormat(CF_UNICODETEXT) or TntClipboard.HasFormat(CF_TEXT) then
      if ActiveControl is TCustomEdit then
        TCustomEdit(ActiveControl).PasteFromClipboard
      else if ActiveControl=tvMain then begin
        n := tvMain.FocusedNode;
        if GetNodeKind(n) in [nkProp, nkConst] then begin
          ResetSearchMatch;
          tvMain.Text[n, IColIdx_Translated] := EncodeControlChars(TntClipboard.AsWideText);
        end;
      end;
  end;

  procedure TfMain.aaPrevEntry(Sender: TObject);
  var n: PVirtualNode;
  begin
    n := tvMain.GetPrevious(tvMain.FocusedNode);
    if n<>nil then ActivateVTNode(tvMain, n, True, True);
  end;

  procedure TfMain.aaReplace(Sender: TObject);
  begin
    Include(SearchParams.Flags, sfReplace);
    ShowFindDialog(Find, MRUSearch.Items, MRUReplace.Items);
  end;

  procedure TfMain.aaSave(Sender: TObject);
  begin
    if FTranslationFileName='' then aaSaveAs(Sender) else FilesSave(FTranslationFileName, FTranslations.IsStreamUnicode);
  end;

  procedure TfMain.aaSaveAs(Sender: TObject);
  const
    IFilterIndex_Ansi    = 1;
    IFilterIndex_Unicode = 2;
  begin
    with TTntSaveDialog.Create(Self) do
      try
        DefaultExt  := STranFileExt;
        Filter      := DKLangConstW('STranFileFilterAnsi')+'|'+DKLangConstW('STranFileFilterUnicode');
         // Determine the default encoding. When saving a new translation, take the LangSource's encoding instead
        FilterIndex := iif(
          ((FTranslationFileName='') and FLangSource.IsFileUnicode) or
            ((FTranslationFileName<>'') and FTranslations.IsStreamUnicode),
          IFilterIndex_Unicode,
          IFilterIndex_Ansi);
        Options     := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
        Title       := DKLangConstW('SDlgTitle_SaveTranFileAs');
        FileName    := DisplayTranFileName;
        if Execute then FilesSave(FileName, FilterIndex=IFilterIndex_Unicode);
      finally
        Free;
      end;
  end;

  procedure TfMain.aaSettings(Sender: TObject);
  begin
    if EditSettings(FPluginHost) then ApplySettings;
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
    if EditTranslationProps(FTranslations, FLangIDSource, FLangIDTranslation) then Modified := True;
  end;

  procedure TfMain.AddNodeTranslationToRepository(Node: PVirtualNode);
  var p: PNodeData;
  begin
    p := tvMain.GetNodeData(Node);
    if (p<>nil) and (FLangIDSource<>0) and (FLangIDTranslation<>0) and (FLangIDSource<>FLangIDTranslation) then
      case p.Kind of
        nkProp: if not (dktsUntranslated in p.pTranProp.TranStates) then
          FRepository.Translations[FLangIDSource, FLangIDTranslation, ReposFixPrefixChar(p.pSrcProp.wsValue)]     := ReposFixPrefixChar(p.pTranProp.wsValue);
        nkConst: if not (dktsUntranslated in p.pTranConst.TranStates) then
          FRepository.Translations[FLangIDSource, FLangIDTranslation, ReposFixPrefixChar(p.pSrcConst.wsDefValue)] := ReposFixPrefixChar(p.pTranConst.wsDefValue);
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
      FilesOpen(sSrcFile, sDisplFile, sTranFile);
    end;
  end;

  procedure TfMain.ApplySettings;
  begin
     // Adjust interface font
    FontFromStr(Font, wsSetting_InterfaceFont);
    ToolbarFont.Assign(Font);
     // Adjust table font
    FontFromStr(tvMain.Font, wsSetting_TableFont);
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
      case MessageBoxW(
          Handle,
          PWideChar(DKLangConstW('SConfirm_FileNotSaved', [DisplayTranFileName])),
          PWideChar(DKLangConstW('SDlgTitle_Confirm')),
          MB_ICONEXCLAMATION or MB_YESNOCANCEL) of
        IDYES: begin
          aSave.Execute;
          Result := not Modified;
        end;
        IDNO: Result := True;
      end;
  end;

  function TfMain.CloseQuery: Boolean;
  begin
    Result := inherited CloseQuery and CheckSave;
  end;

  procedure TfMain.CMFocusChanged(var Msg: TMessage);
  begin
    EnableActions;
  end;

  function TfMain.CopyNodeTranslatedText(Node: PVirtualNode): Boolean;
  var p: PNodeData;
  begin
    Result := False;
    if Node<>nil then begin
      p := tvMain.GetNodeData(Node);
      case p.Kind of
        nkProp: begin
          TntClipboard.AsWideText := p.pTranProp.wsValue;
          Result := True;
        end;
        nkConst: begin
          TntClipboard.AsWideText := p.pTranConst.wsDefValue;
          Result := True;
        end;
      end;
    end;
  end;

  procedure TfMain.dklcMainLanguageChanged(Sender: TObject);
  begin
    UpdateLangItems;
    UpdateStatusBar;
  end;

  procedure TfMain.DoCloseFiles;
  begin
    FreeAndNil(FLangSource);
    FreeAndNil(FDisplayTranslations);
    FreeAndNil(FTranslations);
    FBookmarks.Clear;
    FModified        := False;
    FLanguageSourceFileName  := '';
    FDisplayFileName := '';
    FTranslationFileName    := '';
    if not FIsDestroying then begin
      UpdateCaption;
      UpdateTree;
    end;
  end;

  procedure TfMain.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_wnd_main;
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
     // Create bookmark list
    FBookmarks := TStringList.Create;
     // Create plugin host object
    FPluginHost := TPluginHost.Create(Self); 
     // Update the tree
    UpdateTree;
  end;

  procedure TfMain.DoDestroy;
  begin
    FIsDestroying := True;
    FPluginHost.Free;
     // Close files after unloading plugins
    DoCloseFiles;
    FBookmarks.Free;
    FRepository.Free;
    inherited DoDestroy;
  end;

  procedure TfMain.DoShow;
  begin
    inherited DoShow;
     // Load the plugin modules
    FPluginHost.ScanForPlugins(WideExtractFilePath(WideParamStr(0))+SPluginsRelativePath); 
  end;

  procedure TfMain.EnableActions;
  var
    bOpenFiles, bFocusedNode, bSelection, bTableFocused, bTranEdFocused, bBookmarkVis, bBookmarkSel: Boolean;
    k: TNodeKind;
    i: Integer;
    tbi: TTBCustomItem;
  begin
    k := GetNodeKind(tvMain.FocusedNode);
    bOpenFiles     := FLangSource<>nil;
    bFocusedNode   := bOpenFiles and (k<>nkNone);
    bSelection     := bOpenFiles and (tvMain.SelectedCount>0);
    bTableFocused  := ActiveControl=tvMain;
    bTranEdFocused := ActiveControl=mCurTranEntry;
    bBookmarkVis   := dpBookmarks.Visible;
    bBookmarkSel   := bOpenFiles and (tvBookmarks.FocusedNode<>nil);
     // File
    aSave.Enabled                      := bOpenFiles;
    aSaveAs.Enabled                    := bOpenFiles;
    aClose.Enabled                     := bOpenFiles;
     // Edit
    aCut.Enabled                       := (bTableFocused and (k in [nkProp, nkConst])) or bTranEdFocused;
    aCopy.Enabled                      := (bTableFocused and (k in [nkProp, nkConst])) or (ActiveControl is TCustomEdit);
    aPaste.Enabled                     := (bTableFocused and (k in [nkProp, nkConst])) or bTranEdFocused;
    aFind.Enabled                      := bOpenFiles;
    aFindNext.Enabled                  := bOpenFiles and (sfSearchMade in SearchParams.Flags);
    aBookmarkAdd.Enabled               := bOpenFiles and bBookmarkVis;
    aBookmarkDelete.Enabled            := bBookmarkVis and bBookmarkSel;
    aBookmarkJump.Enabled              := bBookmarkVis and bBookmarkSel;
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
     // Plugins
    for i := 0 to giToolsPluginItems.Count-1 do begin
      tbi := giToolsPluginItems[i];
      if tbi is TPluginMenuItem then tbi.Enabled := TPluginMenuItem(tbi).PluginAction.IsEnabled;
    end;
  end;

  procedure TfMain.EnableActionsNotify(Sender: TObject);
  begin
    EnableActions;
  end;

  function TfMain.FilesClose: LongBool;
  begin
    Result := CheckSave;
    if Result then DoCloseFiles;
  end;

  procedure TfMain.FilesLoad(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString);
  var
    wsDiff: WideString;
    iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer;
    bAutoTranslate: Boolean;
  begin
     // Destroy former langsource storage and translations without confirmation
    DoCloseFiles;
    try
       // Create (and load) new langsource
      FLangSource := TLangSource.Create(wsLangSrcFileName);
       // Create and load, if needed, display-translations
      if wsDisplayFileName<>'' then begin
        FDisplayTranslations := TDKLang_CompTranslations.Create;
        FDisplayTranslations.Text_LoadFromFile(wsDisplayFileName);
      end;
       // Create (and load, if needed) translations. Determine the languages
      FTranslations := TDKLang_CompTranslations.Create;
      if wsTranFileName='' then begin
        FLangIDSource := ILangID_USEnglish;
        FLangIDTranslation   := 0;
      end else begin
        FTranslations.Text_LoadFromFile(wsTranFileName);
        FLangIDSource := StrToIntDef(FTranslations.Params.Values[SDKLang_TranParam_SourceLangID], ILangID_USEnglish);
        FLangIDTranslation   := StrToIntDef(FTranslations.Params.Values[SDKLang_TranParam_LangID],       0);
      end;
       // Now compare the source and the translation and update the latter
      wsDiff := FLangSource.CompareStructureWith(
        FTranslations,
        iCntAddedComps, iCntAddedProps, iCntAddedConsts,
        iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts,
        iCntComps, iCntProps, iCntConsts);
       // Update the properties
      FModified        := False;
      FLanguageSourceFileName  := wsLangSrcFileName;
      FDisplayFileName := wsDisplayFileName;
      FTranslationFileName    := wsTranFileName;
      MRUSource.Add(FLanguageSourceFileName);
      MRUDisplay.Add(FDisplayFileName);
      if FTranslationFileName<>'' then MRUTran.Add(FTranslationFileName);
      UpdateCaption;
       // Show the differences unless this is a new translation
      bAutoTranslate := False;
      if (wsTranFileName<>'') and (wsDiff<>'') then ShowDiffLog(wsDiff, iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts, bAutoTranslate);
       // Reload the tree
      UpdateTree;
    except
       // Destroy the objects in a case of failure
      DoCloseFiles;
      raise;
    end;
     // If no languages specified or source and target languages are the same, show translation properties dialog
    if (FLangIDSource=0) or (FLangIDTranslation=0) or (FLangIDSource=FLangIDTranslation) then aTranProps.Execute;
     // Autotranslate entries if needed
    if bAutoTranslate then TranslateAllNodes(False, nil);
  end;

  function TfMain.FilesOpen(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString): LongBool;
  var wsSourceFile, wsDisplayFile, wsTranFile: WideString;
  begin
    Result := CheckSave;
    if Result then begin
      wsSourceFile  := wsLangSrcFileName;
      wsTranFile    := wsTranFileName;
      wsDisplayFile := wsDisplayFileName;
      Result := SelectLangFiles(wsSourceFile, wsDisplayFile, wsTranFile, MRUSource.Items, MRUDisplay.Items, MRUTran.Items);
      if Result then FilesLoad(wsSourceFile, wsDisplayFile, wsTranFile);
    end;
  end;

  function TfMain.FilesSave(const wsFileName: WideString; bUnicode: LongBool): LongBool;
  begin
    Result := False;
     // Warn if language source and translation encodings differ
    if not bSetting_IgnoreEncodingMismatch and (FLangSource.IsFileUnicode<>bUnicode) then
      case MessageBoxW(
          Application.Handle,
          PWideChar(DKLangConstW(iif(bUnicode, 'SWarnMsg_SavingInUnicode', 'SWarnMsg_SavingInAnsi'))),
          PWideChar(DKLangConstW('SDlgTitle_Confirm')),
          MB_ICONQUESTION or MB_YESNOCANCEL) of
        IDYES: bUnicode := not bUnicode;
        IDNO: { nothing };
        else Exit;
      end;
     // Update translation parameter values
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_SourceLangID] := IntToStr(FLangIDSource);
      Values[SDKLang_TranParam_LangID]       := IntToStr(FLangIDTranslation);
      Values[SDKLang_TranParam_Generator]    := Format('%s %s', [SAppCaption, SAppVersion]);
      Values[SDKLang_TranParam_LastModified] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    end;
     // Save the translations
    FTranslations.Text_SaveToFile(wsFileName, bUnicode, True);
     // Update properties
    FModified := False;
    FTranslationFileName := wsFileName;
    UpdateCaption;
     // Register translation in the MRU list
    MRUTran.Add(FTranslationFileName);
    Result := True;
  end;

  function TfMain.Find(var Params: TSearchParams): Boolean;
  var
    n: PVirtualNode;
    wsSearch, wsEntry: WideString;
    iPatLen, iReplacePatLen, iMatchCount, iMatchPos, iSearchTranStartPos, iReplacedCount: Integer;
    pData: PNodeData;
    bMatches, bReplaceAllMode, bDoReplace, bSearchCancelled: Boolean;
    rItem: TRect;

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

     // Returns True if wc is a non-word character
    function IsNonWordChar(wc: WideChar): Boolean;
    begin
      case wc of
        #0..'/', ':'..'@', '['..'`', '{'..#137, '«', '»': Result := True;
        else                                              Result := False;
      end;
    end;

     // Returns True if s contains wsSearch, search from iStartPos char, also returns the match position in iMatchPos
    function Matches(const ws: WideString; iStartPos: Integer; out iMatchPos: Integer): Boolean;
    var wsWhere: WideString;
    begin
      wsWhere := Copy(ws, iStartPos, MaxInt); 
      if not (sfCaseSensitive in Params.Flags) then wsWhere := WideUpperCase(wsWhere);
      iMatchPos := Pos(wsSearch, wsWhere);
      Result := iMatchPos>0;
      Inc(iMatchPos, iStartPos-1);
       // If whole words are accepted only
      if Result and (sfWholeWordsOnly in Params.Flags) then
        Result :=
          ((iMatchPos=1) or IsNonWordChar(ws[iMatchPos-1])) and
          ((iMatchPos>Length(ws)-iPatLen) or IsNonWordChar(ws[iMatchPos+iPatLen]));
    end;

     // Advances to the next node in the search sequence
    procedure NextNode;
    begin
      if sfSelectedOnly in Params.Flags then
        if sfBackward in Params.Flags then n := GetPreviousSelected(n) else n := tvMain.GetNextSelected(n)
      else
        if sfBackward in Params.Flags then n := tvMain.GetPrevious(n) else n := tvMain.GetNext(n);
    end;

  begin
    MRUSearch.Add(Params.wsSearchPattern);
    if (sfReplace in Params.Flags) and (Params.wsReplacePattern<>'') then MRUReplace.Add(Params.wsReplacePattern);
    bReplaceAllMode := Params.Flags*[sfReplace, sfReplaceAll]=[sfReplace, sfReplaceAll];
     // Prepare the pattern
    wsSearch := Params.wsSearchPattern;
    if not (sfCaseSensitive in Params.Flags) then wsSearch := WideUpperCase(wsSearch);
    iPatLen := Length(wsSearch);
    iReplacePatLen := Length(Params.wsReplacePattern);
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
    else if sfFromNext in Params.Flags then
      NextNode;
     // Search through the nodes
    iMatchCount      := 0;
    iReplacedCount   := 0;
    bSearchCancelled := False;
    while n<>nil do begin
      pData := tvMain.GetNodeData(n);
       // Loop continuously through the value if ReplaceAll mode is on (only used for searching in translated values)
      iSearchTranStartPos := 1; 
      repeat
        bMatches := False;
         // We do not search anything but translated value in Replace mode
        if not (sfReplace in Params.Flags) then begin
           // Test Name
          if not bMatches and (sfSearchNames in Params.Flags) then begin
            case pData.Kind of
              nkComp:  wsEntry := pData.CompSource.CompName;
              nkProp:  wsEntry := pData.pSrcProp.sPropName;
              nkConst: wsEntry := pData.pSrcConst.sName;
              else     wsEntry := '';
            end;
            if wsEntry<>'' then bMatches := Matches(wsEntry, 1, iMatchPos);
          end;
           // Test Original Value
          if not bMatches and (sfSearchOriginal in Params.Flags) then begin
            case pData.Kind of
              nkProp:  if pData.pDisplProp=nil  then wsEntry := pData.pSrcProp.wsValue     else wsEntry := pData.pDisplProp.wsValue;
              nkConst: if pData.pDisplConst=nil then wsEntry := pData.pSrcConst.wsDefValue else wsEntry := pData.pDisplConst.wsDefValue;
              else     wsEntry := '';
            end;
            if wsEntry<>'' then bMatches := Matches(wsEntry, 1, iMatchPos);
          end;
        end;
         // Finally, test Translated Value
        if not bMatches and (sfSearchTranslated in Params.Flags) then begin
          case pData.Kind of
            nkProp:  wsEntry := pData.pTranProp.wsValue;
            nkConst: wsEntry := pData.pTranConst.wsDefValue;
            else     wsEntry := '';
          end;
          if wsEntry<>'' then bMatches := Matches(wsEntry, iSearchTranStartPos, iMatchPos);
        end;
         // Found the match?
        if bMatches then begin
          Inc(iMatchCount);
          ResetSearchMatch;
           // Focus, scroll the node into view and repaint as a search match
          tvMain.FocusedNode := n;
          tvMain.ScrollIntoView(n, True, False);
          FSearchMatchNode := n;
          tvMain.InvalidateNode(FSearchMatchNode);
           // If Replace mode
          if sfReplace in Params.Flags then begin
             // Prompt for replace if needed
            bDoReplace := True;
            if sfPromptOnReplace in Params.Flags then begin
               // On user interaction it'd be good to update the display
              tvMain.Update;
              UpdateCurEntry;
               // Display replace prompt dialog
              with tvMain.GetDisplayRect(n, -1, False, False) do
                rItem := Rect(tvMain.ClientToScreen(TopLeft), tvMain.ClientToScreen(BottomRight));
              case PromptForReplace(wsEntry, Params.wsSearchPattern, iMatchPos, rItem) of
                mrYes: {accept};
                mrYesToAll: Exclude(Params.Flags, sfPromptOnReplace);
                mrNo: bDoReplace := False;
                else begin
                  bDoReplace := False;
                  bSearchCancelled := True;
                end;
              end;
            end;
             // If replace required
            if bDoReplace then begin
              wsEntry := Copy(wsEntry, 1, iMatchPos-1)+Params.wsReplacePattern+Copy(wsEntry, iMatchPos+iPatLen, MaxInt);
              case pData.Kind of
                nkProp:  pData.pTranProp.wsValue     := wsEntry;
                nkConst: pData.pTranConst.wsDefValue := wsEntry;
              end;
              tvMain.InvalidateNode(n);
              Inc(iReplacedCount);
              Modified := True;
            end;
          end;
          iSearchTranStartPos := iMatchPos+iReplacePatLen;
        end;
      until bSearchCancelled or not bMatches or not bReplaceAllMode;
       // If search aborted, or this isn't 'Replace all' call, then exit after a match has been successfully located
      if bSearchCancelled or (bMatches and not bReplaceAllMode) then Break;
       // Advance to the next/previous node
      NextNode;
    end;
     // Update flags and actions
    Params.Flags := Params.Flags+[sfSearchMade, sfFromNext];
    if iReplacedCount>0 then UpdateCurEntry;
    EnableActions;
     // Reset the search match after replace
    if sfReplace in Params.Flags then ResetSearchMatch;
     // Inform the user about results
    if bSearchCancelled then
      Result := True
    else begin
      Result := iMatchCount>0;
      if not Result then
        Info(DKLangConstW('SMsg_NoSearchResults', [Params.wsSearchPattern]))
      else if Params.Flags*[sfReplace, sfReplaceAll]=[sfReplace, sfReplaceAll] then
        Info(DKLangConstW('SMsg_ReplacedInfo', [iReplacedCount, Params.wsSearchPattern]));
    end;
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
    MRUSearch.LoadFromRegIni (rif, SRegSection_MRUSearch);
    MRUReplace.LoadFromRegIni(rif, SRegSection_MRUReplace);
     // Load settings
    LangManager.LanguageID          := rif.ReadInteger(SRegSection_Preferences, 'Language',               ILangID_USEnglish);
    sbarMain.Visible                := rif.ReadBool   (SRegSection_Preferences, 'StatusBarVisible',       True);
    wsSetting_InterfaceFont         := rif.ReadString (SRegSection_Preferences, 'InterfaceFont',          FontToStr(Font));
    wsSetting_TableFont             := rif.ReadString (SRegSection_Preferences, 'TableFont',              wsSetting_InterfaceFont);
    wsSetting_RepositoryDir         := rif.ReadString (SRegSection_Preferences, 'RepositoryPath',         ExtractFileDir(ParamStr(0)));
    bSetting_ReposRemovePrefix      := rif.ReadBool   (SRegSection_Preferences, 'ReposRemovePrefix',      True);
    bSetting_ReposAutoAdd           := rif.ReadBool   (SRegSection_Preferences, 'ReposAutoAdd',           True);
    bSetting_IgnoreEncodingMismatch := rif.ReadBool   (SRegSection_Preferences, 'IgnoreEncodingMismatch', False);
     // Load search params
    SearchParams.wsSearchPattern    := rif.ReadString (SRegSection_Search, 'SearchPattern',    '');
    SearchParams.wsReplacePattern   := rif.ReadString (SRegSection_Search, 'ReplacePattern',   '');
    SearchParams.Flags := [];
    if rif.ReadBool(SRegSection_Search, 'CaseSensitive',    False) then Include(SearchParams.Flags, sfCaseSensitive);
    if rif.ReadBool(SRegSection_Search, 'WholeWordsOnly',   False) then Include(SearchParams.Flags, sfWholeWordsOnly);
    if rif.ReadBool(SRegSection_Search, 'SelectedOnly',     False) then Include(SearchParams.Flags, sfSelectedOnly);
    if rif.ReadBool(SRegSection_Search, 'PromptOnReplace',  True)  then Include(SearchParams.Flags, sfPromptOnReplace);
    if rif.ReadBool(SRegSection_Search, 'EntireScope',      False) then Include(SearchParams.Flags, sfEntireScope);
    if rif.ReadBool(SRegSection_Search, 'SearchNames',      False) then Include(SearchParams.Flags, sfSearchNames);
    if rif.ReadBool(SRegSection_Search, 'SearchOriginal',   False) then Include(SearchParams.Flags, sfSearchOriginal);
    if rif.ReadBool(SRegSection_Search, 'SearchTranslated', True)  then Include(SearchParams.Flags, sfSearchTranslated);
    if rif.ReadBool(SRegSection_Search, 'Backward',         False) then Include(SearchParams.Flags, sfBackward);
     // Load the repository
    FRepository.LoadFromFile(WideIncludeTrailingPathDelimiter(wsSetting_RepositoryDir)+SRepositoryFileName);
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
    MRUSearch.SaveToRegIni (rif, SRegSection_MRUSearch);
    MRUReplace.SaveToRegIni(rif, SRegSection_MRUReplace);
     // Save settings
    rif.WriteInteger(SRegSection_Preferences, 'Language',               LangManager.LanguageID);
    rif.WriteBool   (SRegSection_Preferences, 'StatusBarVisible',       sbarMain.Visible);
    rif.WriteString (SRegSection_Preferences, 'InterfaceFont',          wsSetting_InterfaceFont);
    rif.WriteString (SRegSection_Preferences, 'TableFont',              wsSetting_TableFont);
    rif.WriteString (SRegSection_Preferences, 'RepositoryPath',         wsSetting_RepositoryDir);
    rif.WriteBool   (SRegSection_Preferences, 'ReposRemovePrefix',      bSetting_ReposRemovePrefix);
    rif.WriteBool   (SRegSection_Preferences, 'ReposAutoAdd',           bSetting_ReposAutoAdd);
    rif.WriteBool   (SRegSection_Preferences, 'IgnoreEncodingMismatch', bSetting_IgnoreEncodingMismatch);
     // Save search params
    rif.WriteString (SRegSection_Search, 'SearchPattern',    SearchParams.wsSearchPattern);
    rif.WriteString (SRegSection_Search, 'ReplacePattern',   SearchParams.wsReplacePattern);
    rif.WriteBool   (SRegSection_Search, 'CaseSensitive',    sfCaseSensitive    in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'WholeWordsOnly',   sfWholeWordsOnly   in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'SelectedOnly',     sfSelectedOnly     in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'PromptOnReplace',  sfPromptOnReplace  in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'EntireScope',      sfEntireScope      in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'SearchNames',      sfSearchNames      in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'SearchOriginal',   sfSearchOriginal   in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'SearchTranslated', sfSearchTranslated in SearchParams.Flags);
    rif.WriteBool   (SRegSection_Search, 'Backward',         sfBackward         in SearchParams.Flags);
     // Save the repository
    FRepository.SaveToFile(WideIncludeTrailingPathDelimiter(wsSetting_RepositoryDir)+SRepositoryFileName);
  end;

  function TfMain.GetDisplayFileName: WideString;
  begin
    Result := FDisplayFileName; 
  end;

  function TfMain.GetDisplayTranFileName: WideString;
  begin
    Result := iif(FTranslationFileName='', STranFileDefaultName, FTranslationFileName);
  end;

  function TfMain.GetIsFileOpen: LongBool;
  begin
    Result := FLangSource<>nil;
  end;

  function TfMain.GetIsModified: LongBool;
  begin
    Result := FModified;
  end;

  function TfMain.GetLangIDSource: LANGID;
  begin
    Result := FLangIDSource;
  end;

  function TfMain.GetLangIDTranslation: LANGID;
  begin
    Result := FLangIDTranslation;
  end;

  function TfMain.GetLanguageSourceFileName: WideString;
  begin
    Result := FLanguageSourceFileName;
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

  function TfMain.GetSelectedItemCount: Integer;
  begin
    Result := tvMain.SelectedCount;
  end;

  function TfMain.GetTranslationFileName: WideString;
  begin
    Result := FTranslationFileName;
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
    ResetSearchMatch;
    FSettingTranTextFromEditor := True;
    try
      tvMain.Text[tvMain.FocusedNode, IColIdx_Translated] := EncodeControlChars(mCurTranEntry.Text);
    finally
      FSettingTranTextFromEditor := False;
    end;
  end;

  procedure TfMain.PluginLoaded(PluginEntry: TPluginEntry);
  var
    i: Integer;
    Action: IDKLang_TranEd_PluginAction;
    pmi: TPluginMenuItem;
  begin
    for i := 0 to PluginEntry.ActionCount-1 do begin
      Action := PluginEntry.Actions[i];
       // Create separator if needed
      if ((i=0) or Action.StartsGroup) and (giToolsPluginItems.Count>0) then
        giToolsPluginItems.Add(TTBXSeparatorItem.Create(Self));
       // Create menu item and link it to plugin and its action
      pmi := TPluginMenuItem.Create(Self);
      pmi.PluginEntry  := PluginEntry;
      pmi.PluginAction := Action;
      giToolsPluginItems.Add(pmi);
    end;
  end;

  procedure TfMain.PluginUnloading(PluginEntry: TPluginEntry);
  var
    i: Integer;
    tbi: TTBCustomItem;
  begin
     // Find and destroy all menu items linked to plugin
    i := giToolsPluginItems.Count-1;
    while i>=0 do begin
      tbi := giToolsPluginItems[i];
      if (tbi is TPluginMenuItem) and (TPluginMenuItem(tbi).PluginEntry=PluginEntry) then begin
        giToolsPluginItems.Delete(i);
         // Destroy related separator item, if any
        if (i>0) and (giToolsPluginItems[i-1] is TTBXSeparatorItem) then begin
          giToolsPluginItems.Delete(i-1);
          Dec(i);
        end;
      end;
      Dec(i);
    end;
  end;

  procedure TfMain.RefreshBookmarks;
  begin
    tvBookmarks.RootNodeCount := FBookmarks.Count;
    tvBookmarks.Invalidate;
    EnableActions;
  end;

  procedure TfMain.ResetSearchMatch;
  begin
    if FSearchMatchNode<>nil then begin
      tvMain.InvalidateNode(FSearchMatchNode);
      FSearchMatchNode := nil;
    end;
  end;

  procedure TfMain.SetModified(Value: Boolean);
  begin
    if FModified<>Value then begin
      FModified := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.SetTranslationFileName(const Value: WideString);
  begin
    if FTranslationFileName<>Value then begin
      FTranslationFileName := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.TranslateAllNodes(bSelectedOnly: Boolean; Translator: IDKLang_TranEd_Translator);
  var n: PVirtualNode;
  begin
    if bSelectedOnly then n := tvMain.GetFirstSelected else n := tvMain.GetFirst;
    while n<>nil do begin
      TranslateNode(n, Translator);
      if bSelectedOnly then n := tvMain.GetNextSelected(n) else n := tvMain.GetNext(n);
    end;
     // Update display
    tvMain.Invalidate;
    UpdateStatusBar;
  end;

  procedure TfMain.TranslateNode(Node: PVirtualNode;  Translator: IDKLang_TranEd_Translator);
  var
    p: PNodeData;
    ws: WideString;

    function GetTranslation(const wsSource: WideString; out wsTranslated: WideString): Boolean;
    begin
       // Translation using Respository
      if Translator=nil then begin
        wsTranslated := FRepository.Translations[FLangIDSource, FLangIDTranslation, wsSource];
        Result := wsTranslated<>'';
       // Translation with the plugin
      end else
        Result := Translator.Translate(FLangIDSource, FLangIDTranslation, wsSource, wsTranslated);
    end;

  begin
    p := tvMain.GetNodeData(Node);
    if (p<>nil) and (FLangIDSource<>0) and (FLangIDTranslation<>0) and (FLangIDSource<>FLangIDTranslation) then
      case p.Kind of
        nkProp:
          if (dktsUntranslated in p.pTranProp.TranStates) and GetTranslation(ReposFixPrefixChar(p.pSrcProp.wsValue), ws) then begin
            with p.pTranProp^ do begin
              wsValue    := ws;
              TranStates := TranStates-[dktsUntranslated]+[dktsAutotranslated];
            end;
            Modified := True;
          end;
        nkConst:
          if (dktsUntranslated in p.pTranConst.TranStates) and GetTranslation(ReposFixPrefixChar(p.pSrcConst.wsDefValue), ws) then begin
            with p.pTranConst^ do begin
              wsDefValue := ws;
              wsValue    := ws;
              TranStates := TranStates-[dktsUntranslated]+[dktsAutotranslated];
            end;
            Modified := True;
          end;
      end;
  end;

  procedure TfMain.TranslateSelected(Translator: IDKLang_TranEd_Translator);
  begin
    TranslateAllNodes(True, Translator);
  end;

  procedure TfMain.tvBookmarksChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  begin
    EnableActions;
  end;

  procedure TfMain.tvBookmarksGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    case Kind of
      ikNormal, ikSelected: ImageIndex := iiBookmark;
      ikState: ImageIndex := aiNodeKindImageIndexes[GetNodeKind(PVirtualNode(FBookmarks.Objects[Node.Index]))];
    end;
  end;

  procedure TfMain.tvBookmarksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  begin
    CellText := FBookmarks[Node.Index];
  end;

  procedure TfMain.tvBookmarksKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
  begin
    if (CharCode=VK_RETURN) and (Shift=[]) then begin
      DoDefault := False;
      aBookmarkJump.Execute;
    end;
  end;

  procedure TfMain.tvMainAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
  begin
     // If this is a search match
    if Node=FSearchMatchNode then
      with TargetCanvas do begin
        Brush.Style := bsClear;
        Pen.Color   := CLine_SearchMatch;
        Rectangle(ItemRect);
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
     // If this is a search match node
    if Node=FSearchMatchNode then
      ItemColor := CBack_SearchMatch
     // Else paint the background according to node kind
    else
      ItemColor := aColors[GetNodeKind(Node)];
    EraseAction := eaColor;
  end;

  procedure TfMain.tvMainChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  begin
    ResetSearchMatch;
    UpdateEntryProps;
    UpdateCurEntry;
    UpdateCurBookmark;
    EnableActions;
  end;

  procedure TfMain.tvMainEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  begin
    UpdateCurEntry;
  end;

  procedure TfMain.tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
  begin
     // It is allowed to edit translated values only
    Allowed := (GetNodeKind(Node) in [nkProp, nkConst]) and (Column=IColIdx_Translated);
    if Allowed then ResetSearchMatch;
  end;

  procedure TfMain.tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    case Kind of
      ikNormal, ikSelected:
        case Column of
          IColIdx_Name: ImageIndex := aiNodeKindImageIndexes[GetNodeKind(Node)];
          IColIdx_Translated: if dktsUntranslated in GetNodeTranStates(Node) then ImageIndex := iiUntranslated;
        end;
       // Draw a bookmark image if node is bookmarked
      ikState: if (Column=IColIdx_Name) and (FBookmarks.IndexOfObject(Pointer(Node))>=0) then ImageIndex := iiBookmark;
    end;
  end;

  procedure TfMain.tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  var p: PNodeData;
  begin
    p := Sender.GetNodeData(Node);
    CellText := '';
    case TextType of
       // Normal text
      ttNormal:
        case p.Kind of
          nkComp: if Column=IColIdx_Name then CellText := p.CompSource.CompName;
          nkProp:
            case Column of
              IColIdx_Name: CellText := p.pSrcProp.sPropName;
              IColIdx_ID:   CellText := IntToStr(p.pSrcProp.iID);
              IColIdx_Original: begin
                if p.pDisplProp=nil then CellText := p.pSrcProp.wsValue else CellText := p.pDisplProp.wsValue;
                CellText := EncodeControlChars(CellText);
              end;
              IColIdx_Translated: CellText := EncodeControlChars(p.pTranProp.wsValue);
            end;
          nkConsts: if Column=IColIdx_Name then CellText := DKLangConstW('SNode_Constants');
          nkConst:
            case Column of
              IColIdx_Name: CellText := p.pSrcConst.sName;
              IColIdx_Original: begin
                if p.pDisplConst=nil then CellText := p.pSrcConst.wsDefValue else CellText := p.pDisplConst.wsDefValue;
                CellText := EncodeControlChars(CellText);
              end;
              IColIdx_Translated: CellText := EncodeControlChars(p.pTranConst.wsDefValue);
            end;
        end;
       // Static text
      ttStatic: if (Column=IColIdx_Name) and (p.Kind in [nkComp, nkConsts]) then CellText := WideFormat('(%d)', [Sender.ChildCount[Node]]);
    end;
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
  var p: PNodeData;
  begin
    p := Sender.GetNodeData(Node);
    case p.Kind of
      nkProp:
        with p.pTranProp^ do begin
          wsValue    := DecodeControlChars(NewText);
          TranStates := TranStates-[dktsUntranslated, dktsAutotranslated];
        end;
      nkConst:
        with p.pTranConst^ do begin
          wsValue    := DecodeControlChars(NewText);
          wsDefValue := wsValue;
          TranStates := TranStates-[dktsUntranslated, dktsAutotranslated];
        end;
      else Exit;
    end;
    Modified := True;
     // If node is the focused one, update the translated value editor
    if not FSettingTranTextFromEditor and (Sender.FocusedNode=Node) then UpdateCurEntry;
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
  const awsMod: Array[Boolean] of WideString = ('', '*');
  begin
    Caption := WideFormat('[%s%s] - %s', [WideExtractFileName(DisplayTranFileName), awsMod[Modified], SAppCaption]);
    Application.Title := Caption;
  end;

  procedure TfMain.UpdateCurBookmark;
  var
    n: PVirtualNode;
    idxBookmark: Integer;
  begin
    n := tvMain.FocusedNode;
    if n<>nil then begin
      idxBookmark := FBookmarks.IndexOfObject(Pointer(n));
      if idxBookmark>=0 then ActivateVTNode(tvBookmarks, FindVTNodeByIndex(tvBookmarks, idxBookmark), True, True);
    end;
  end;

  procedure TfMain.UpdateCurEntry;
  var
    p: PNodeData;
    wsSrc, wsTran: WideString;
    bEnable: Boolean;
  begin
    wsSrc  := '';
    wsTran := '';
    bEnable := False;
    p := tvMain.GetNodeData(tvMain.FocusedNode);
    if p<>nil then begin
      bEnable := p.Kind in [nkProp, nkConst];
      case p.Kind of
        nkProp: begin
          wsSrc  := p.pSrcProp.wsValue;
          wsTran := p.pTranProp.wsValue;
        end;
        nkConst: begin
          wsSrc  := p.pSrcConst.wsDefValue;
          wsTran := p.pTranConst.wsDefValue;
        end;
      end;
    end;
     // Update curent entry editors
    FUpdatingCurEntryEditor := True;
    try
      mCurSrcEntry.Text  := wsSrc;
      mCurTranEntry.Text := wsTran;
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
      with smLanguage[i] do Checked := Tag=LangManager.LanguageID;
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
      Items[ISBPanelIdx_CompCount].Caption       := DKLangConstW('SStatusBar_CompCount',       [iCntComp]);
      Items[ISBPanelIdx_PropCount].Caption       := DKLangConstW('SStatusBar_PropCount',       [iCntProp, iCntPropUntr]);
      Items[ISBPanelIdx_ConstCount].Caption      := DKLangConstW('SStatusBar_ConstCount',      [iCntConst, iCntConstUntr]);
      Items[ISBPanelIdx_ReposEntryCount].Caption := DKLangConstW('SStatusBar_ReposEntryCount', [FRepository.EntryCount]);
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


