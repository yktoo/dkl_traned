unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, XPMan, DKLang, ConsVars,
  Placemnt, ImgList, TB2Item, ActnList, VirtualTrees, ExtCtrls,
  TBXStatusBars, TBX, TB2Dock, TB2Toolbar, TB2MRU;

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
        CompSource: TComponentSource;             // Link to component source
        TranComp:   TDKLang_CompTranslation);     // Link to component translation
      nkProp: (
        pSrcProp:  PPropertySource;               // Link to property source
        pTranProp: PDKLang_PropValueTranslation); // Link to property translation
      nkConst: (
        pSrcConst: PDKLang_Constant;              // Link to constant source 
        pTranConst: PDKLang_Constant);            // Link to constant translation
  end;

  TfMain = class(TForm)
    aAbout: TAction;
    aClose: TAction;
    aExit: TAction;
    alMain: TActionList;
    aNew: TAction;
    aOpen: TAction;
    aSave: TAction;
    aSaveAs: TAction;
    aSettings: TAction;
    bAbout: TTBXItem;
    bExit: TTBXItem;
    bNew: TTBXItem;
    bOpen: TTBXItem;
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
    ilMain: TTBImageList;
    iNew: TTBXItem;
    iOpen: TTBXItem;
    iSave: TTBXItem;
    iSaveAs: TTBXItem;
    iSettings: TTBXItem;
    iToggleStatusBar: TTBXVisibilityToggleItem;
    iToggleToolbar: TTBXVisibilityToggleItem;
    iViewSep1: TTBXSeparatorItem;
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
    tvMain: TVirtualStringTree;
    MRUSource: TTBMRUList;
    MRUTran: TTBMRUList;
    aTranProps: TAction;
    iTranProps: TTBXItem;
    MRUTargetApp: TTBMRUList;
    aJumpNextUntranslated: TAction;
    aJumpPrevUntranslated: TAction;
    iSepJumpPrevUntranslated: TTBXSeparatorItem;
    iJumpNextUntranslated: TTBXItem;
    iJumpPrevUntranslated: TTBXItem;
    tbSep2: TTBXSeparatorItem;
    bJumpNextUntranslated: TTBXItem;
    bJumpPrevUntranslated: TTBXItem;
    procedure aaAbout(Sender: TObject);
    procedure aaClose(Sender: TObject);
    procedure aaExit(Sender: TObject);
    procedure aaNew(Sender: TObject);
    procedure aaOpen(Sender: TObject);
    procedure aaSave(Sender: TObject);
    procedure aaSaveAs(Sender: TObject);
    procedure aaSettings(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fpMainRestorePlacement(Sender: TObject);
    procedure fpMainSavePlacement(Sender: TObject);
    procedure tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvMainCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
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
  private
     // Language source storage
    FLangSource: TLangSource;
     // Loaded or new translations
    FTranslations: TDKLang_CompTranslations;
     // Flag that command line parameters have been checked
    FCmdLineChecked: Boolean;
     // Prop storage
    FModified: Boolean;
    FTranFileName: String;
    FSourceFileName: String;
     // Redisplays the language source tree
    procedure UpdateTree;
     // Checks whether translation file is modified and asks to save it
    function  CheckSave: Boolean;
     // Uses the specified file names as suggested, shows select files dialog and loads the files. Returns True if user
     //   clicked OK
    function  OpenFiles(const sLangSrcFileName, sTranFileName: String; bNewMode: Boolean): Boolean;
     // File loading/saving
    procedure DoLoad(const sLangSrcFileName, sTranFileName: String);
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
     // App events
    procedure AppHint(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
     // Prop handlers
    procedure SetModified(Value: Boolean);
    procedure SetTranFileName(const Value: String);
    function  GetDisplayTranFileName: String;
  public
     // Props
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
uses StdCtrls, Registry, udSettings, udAbout, udOpenFiles, udDiffLog, udTranProps;

   //===================================================================================================================
   // TStrEditLinkEx
   //===================================================================================================================
type
  TStrEditMoveDirection = (smdNone, smdEnter, smdUp, smdDown);

  TStrEditLinkEx = class(TInterfacedObject, IVTEditLink)
  private
     // Компонент редактора
    FEdit: TCustomEdit;
     // True, если используется TMemo вместо TEdit
    FMultiline: Boolean;
     // A back reference to the tree calling
    FTree: TVirtualStringTree;
     // The node being edited
    FNode: PVirtualNode;
     // The column of the node being edited
    FColumn: Integer;
     // Used to capture some important messages regardless of the type of control we use
    FOldEditWndProc: TWndMethod;
     // Флаг прерывания процесса редактирования
    FEndingEditing: Boolean;
     // Обработчик оконной процедуры контрола
    procedure EditWindowProc(var Msg: TMessage);
     // Заканчивает редактирование (успешно) и сдвигает выделение в дереве при Direction<>smdNone, возвращает True, если
     //   удалось
    function  MoveSelection(Direction: TStrEditMoveDirection): Boolean;
     // IVTEditLink
    function  BeginEdit: Boolean; stdcall;
    function  CancelEdit: Boolean; stdcall;
    function  EndEdit: Boolean; stdcall;
    function  PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    function  GetBounds: TRect; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  public
    destructor Destroy; override;
  end;

  function TStrEditLinkEx.BeginEdit: Boolean;
  begin
    Result := True;
    FEdit.Show;
    FEdit.SetFocus;
     // Set a window procedure hook (aka subclassing) to get notified about important messages
    FOldEditWndProc := FEdit.WindowProc;
    FEdit.WindowProc := EditWindowProc;
  end;

  function TStrEditLinkEx.CancelEdit: Boolean;
  begin
    Result := True;
     // Restore the edit's window proc
    FEdit.WindowProc := FOldEditWndProc;
    FEdit.Hide;
  end;

  destructor TStrEditLinkEx.Destroy;
  begin
    FEdit.Free;
    if (FTree<>nil) and not (csDestroying in FTree.ComponentState) then FTree.SetFocus;
    inherited Destroy;
  end;

  procedure TStrEditLinkEx.EditWindowProc(var Msg: TMessage);
  var smd: TStrEditMoveDirection;
  begin
    case Msg.Msg of
      WM_GETDLGCODE: begin
        FOldEditWndProc(Msg);
        Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
        Exit;
      end;
      WM_KEYDOWN:
        if ((GetKeyState(VK_SHIFT) or GetKeyState(VK_CONTROL) or GetKeyState(VK_MENU)) and $80=0) then begin
          smd := smdNone;
          case Msg.WParam of
            VK_UP:     if not FMultiline then smd := smdUp;
            VK_DOWN:   if not FMultiline then smd := smdDown;
            VK_RETURN: if not FMultiline then smd := smdEnter;
            VK_ESCAPE: begin
              FTree.CancelEditNode;
              Exit;
            end;
          end;
          if (smd<>smdNone) and MoveSelection(smd) then Exit;
        end;
      WM_KILLFOCUS: MoveSelection(smdNone);
    end;
    FOldEditWndProc(Msg);
  end;

  function TStrEditLinkEx.EndEdit: Boolean;
  var s: String;
  begin
    Result := True;
    if FEdit.Modified then begin
      if FMultiline then s := FEdit.Text else s := MultilineToLine(FEdit.Text);
      TVirtualStringTree(FTree).Text[FNode, FColumn] := s;
    end;
    FEdit.Hide;
  end;

  function TStrEditLinkEx.GetBounds: TRect;
  begin
    Result := FEdit.BoundsRect;
  end;

  function TStrEditLinkEx.MoveSelection(Direction: TStrEditMoveDirection): Boolean;
  var n: PVirtualNode;
  begin
    Result := not FEndingEditing;
     // Сдвигаем выделение
    if Result then
      with FTree do begin
        n := FocusedNode;
         // Определяем узел (строку) и столбец, куда двигать выделение
        case Direction of
          smdUp:   n := GetPrevious(n);
          smdDown: n := GetNext(n);
        end;
         // Двигаем
        if n<>nil then begin
          FEndingEditing := True;
          EndEditNode;
          FocusedNode := n;
          Selected[n] := True;
        end;
      end;
  end;

  function TStrEditLinkEx.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
  var s: String;
  begin
    FTree := Tree as TVirtualStringTree;
    FNode := Node;
    FColumn := Column;
    FreeAndNil(FEdit);
     // Если нажат Ctrl - создаём многострочный редактор
    FMultiline := GetKeyState(VK_CONTROL) and $80<>0;
     // Получаем текст
    s := TVirtualStringTree(Tree).Text[Node, Column];
     // Создаём контрол
    if FMultiline then FEdit := TMemo.Create(nil) else FEdit := TEdit.Create(nil);
     // Настраиваем контрол
    with FEdit do begin
      Visible  := False;
      Parent   := FTree;
      if FMultiline then begin
        TMemo(FEdit).ScrollBars := ssBoth;
        TMemo(FEdit).WordWrap   := False;
        Text := LineToMultiline(s);
      end else
        Text := s;
      Modified := False;
    end;
    Result := True;
  end;

  procedure TStrEditLinkEx.ProcessMessage(var Message: TMessage);
  begin
    FEdit.WindowProc(Message);
  end;

  procedure TStrEditLinkEx.SetBounds(R: TRect);
  begin
    FTree.Header.Columns.GetColumnBounds(FColumn, R.Left, R.Right);
     // If a TMemo, increase height
    if FMultiline then R.Bottom := R.Top+200;
    FEdit.BoundsRect := R;
  end;

   //===================================================================================================================
   //  TfMain
   //===================================================================================================================

  procedure TfMain.aaAbout(Sender: TObject);
  begin
    ShowAbout;
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
  var Node: PVirtualNode;
  begin
    Node := tvMain.FocusedNode;
    if Node=nil then Node := tvMain.GetFirst else Node := tvMain.GetNext(Node);
    while Node<>nil do begin
      if IsNodeUntranslated(Node) then begin
        ActivateVTNode(tvMain, Node, True);
        Break;
      end;
      Node := tvMain.GetNext(Node);
    end;
  end;

  procedure TfMain.aaJumpPrevUntranslated(Sender: TObject);
  var Node: PVirtualNode;
  begin
    Node := tvMain.GetPrevious(tvMain.FocusedNode);
    while Node<>nil do begin
      if IsNodeUntranslated(Node) then begin
        ActivateVTNode(tvMain, Node, True);
        Break;
      end;
      Node := tvMain.GetPrevious(Node);
    end;
  end;

  procedure TfMain.aaNew(Sender: TObject);
  begin
    OpenFiles(FSourceFileName, '', True);
  end;

  procedure TfMain.aaOpen(Sender: TObject);
  begin
    OpenFiles(FSourceFileName, FTranFileName, False);
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
    EditSettings;
  end;

  procedure TfMain.aaTranProps(Sender: TObject);
  begin
    if EditTranslationProps(FTranslations, MRUTargetApp.Items) then Modified := True;
  end;

  procedure TfMain.AppHint(Sender: TObject);
  begin
    sbarMain.Panels[0].Caption := Application.Hint;
  end;

  procedure TfMain.AppIdle(Sender: TObject; var Done: Boolean);
  var
    i: Integer;
    sSrcFile, sTranFile: String;

    procedure UseFile(const sFileName: String);
    var sExt: String;
    begin
      if sFileName<>'' then begin
        sExt := ExtractFileExt(sFileName);
         // If the file has language source file extension
        if AnsiSameText(sExt, SLangSourceFileDotExt) then begin
          if sSrcFile='' then sSrcFile := sFileName;
         // Else assume it a translation file
        end else if sTranFile='' then
          sTranFile := sFileName;
      end;
    end;

  begin
    if not FCmdLineChecked then begin
      FCmdLineChecked := True;
       // Check command line parameters
      sSrcFile  := '';
      sTranFile := '';
      for i := 1 to 2 do UseFile(ParamStr(i));
      if sSrcFile<>'' then DoLoad(sSrcFile, sTranFile) else OpenFiles(sSrcFile, sTranFile, False);
    end;
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
    FreeAndNil(FTranslations);
    FModified       := False;
    FSourceFileName := '';
    FTranFileName   := '';
    if bUpdateDisplay then begin
      UpdateCaption;
      UpdateTree;
    end;
  end;

  procedure TfMain.DoLoad(const sLangSrcFileName, sTranFileName: String);
  var sDiff: String;
  begin
     // Destroy former langsource storage and translations
    CloseProject(True);
    try
       // Create (and load) new langsource
      FLangSource := TLangSource.Create(sLangSrcFileName);
       // Create (and load, if needed) translations
      FTranslations := TDKLang_CompTranslations.Create;
      if sTranFileName<>'' then FTranslations.LoadFromFile(sTranFileName);
       // Now compare the source and the translation and update the latter
      sDiff := FLangSource.CompareStructureWith(FTranslations);
       // Show the differences unless this is a new translation 
      if (sTranFileName<>'') and (sDiff<>'') then ShowDiffLog(sDiff);
       // Update properties
      FModified       := False;
      FSourceFileName := sLangSrcFileName;
      FTranFileName   := sTranFileName;
      MRUSource.Add(FSourceFileName);
      if FTranFileName<>'' then MRUTran.Add(FTranFileName);
      UpdateCaption;
       // Reload the tree
      UpdateTree;
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
  var bOpenFiles: Boolean;
  begin
    bOpenFiles := FLangSource<>nil;
    aSave.Enabled      := bOpenFiles;
    aSaveAs.Enabled    := bOpenFiles;
    aClose.Enabled     := bOpenFiles;
    aTranProps.Enabled := bOpenFiles;
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
     // Update the tree
    UpdateTree;
  end;

  procedure TfMain.FormDestroy(Sender: TObject);
  begin
    CloseProject(False);
  end;

  procedure TfMain.fpMainRestorePlacement(Sender: TObject);
  begin
    TBRegLoadPositions(Self, HKEY_CURRENT_USER, SRegKey_Root);
    MRUSource.LoadFromRegIni   (fpMain.RegIniFile, SRegSection_MRUSource);
    MRUTran.LoadFromRegIni     (fpMain.RegIniFile, SRegSection_MRUTranslation);
    MRUTargetApp.LoadFromRegIni(fpMain.RegIniFile, SRegSection_MRUTargetApp);
  end;

  procedure TfMain.fpMainSavePlacement(Sender: TObject);
  begin
    TBRegSavePositions(Self, HKEY_CURRENT_USER, SRegKey_Toolbars);
    MRUSource.SaveToRegIni   (fpMain.RegIniFile, SRegSection_MRUSource);
    MRUTran.SaveToRegIni     (fpMain.RegIniFile, SRegSection_MRUTranslation);
    MRUTargetApp.SaveToRegIni(fpMain.RegIniFile, SRegSection_MRUTargetApp);
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

  function TfMain.OpenFiles(const sLangSrcFileName, sTranFileName: String; bNewMode: Boolean): Boolean;
  var sSourceFile, sTranFile: String;
  begin
    sSourceFile := sLangSrcFileName;
    sTranFile   := sTranFileName;
    Result := SelectLangFiles(sSourceFile, sTranFile, MRUSource.Items, MRUTran.Items, bNewMode);
    if Result then DoLoad(sSourceFile, sTranFile);
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

  procedure TfMain.tvMainCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
  begin
    EditLink := TStrEditLinkEx.Create;
  end;

  procedure TfMain.tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
  begin
     // It is allowed to edit translated values only 
    Allowed := (GetNodeKind(Node) in [nkProp, nkConst]) and (Column=IColIdx_Translated);
  end;

  procedure TfMain.tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  begin
    EnableActions;
  end;

  procedure TfMain.tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    if Column=0 then
      case GetNodeKind(Node) of
        nkComp:   ImageIndex := iiNode_Comp;
        nkProp:   ImageIndex := iiNode_Prop;
        nkConsts: ImageIndex := iiNode_Consts;
        nkConst:  ImageIndex := iiNode_Const;
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
              IColIdx_Original:   s := MultilineToLine(p.pSrcProp.sValue);
              IColIdx_Translated: s := MultilineToLine(p.pTranProp.sValue);
            end;
          nkConsts: if Column=IColIdx_Name then s := SNode_Constants;
          nkConst:
            case Column of
              IColIdx_Name:       s := p.pSrcConst.sName;
              IColIdx_Original:   s := MultilineToLine(p.pSrcConst.sDefValue);
              IColIdx_Translated: s := MultilineToLine(p.pTranConst.sDefValue);
            end;
        end;
       // Static text
      ttStatic: if (Column=IColIdx_Name) and (p.Kind in [nkComp, nkConsts]) then s := Format('(%d)', [Sender.ChildCount[Node]]);
    end;
    CellText := s;
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
        p.CompSource := FLangSource.ComponentSources[Node.Index];
        p.TranComp   := FTranslations.FindComponentName(p.CompSource.CompName);
        Sender.ChildCount[Node] := p.CompSource.PropertySources.Count;
      end;
      nkProp: begin
        p.pSrcProp := pParent.CompSource.PropertySources[Node.Index];
        if pParent.TranComp<>nil then p.pTranProp := pParent.TranComp.FindPropByID(p.pSrcProp.iID);
      end;
      nkConsts: Sender.ChildCount[Node] := FLangSource.Constants.Count;
      nkConst: begin
        p.pSrcConst  := FLangSource.Constants[Node.Index];
        p.pTranConst := FTranslations.Constants.FindConstName(p.pSrcConst.sName);
      end;
    end;
     // Expand the whole tree
    Include(InitialStates, ivsExpanded);
  end;

  procedure TfMain.tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
  begin
     // On Enter or Ctrl+Enter start editing
    if (Shift*[ssShift, ssAlt]=[]) and (CharCode=VK_RETURN) and not Sender.IsEditing then begin
      DoDefault := False;
      with Sender do
        if FocusedNode<>nil then EditNode(FocusedNode, FocusedColumn);
    end;
  end;

  procedure TfMain.tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
  var
    p: PNodeData;
    s: String;
  begin
    s := NewText;
    p := Sender.GetNodeData(Node);
    case p.Kind of
      nkProp: begin
        with p.pTranProp^ do begin
          sValue := NewText;
          States := States-[dklptsUntranslated];
        end;
        Modified := True;
      end;
      nkConst: begin
        with p.pTranConst^ do begin
          sValue    := NewText;
          sDefValue := sValue;
          States    := States-[dklcsUntranslated];
        end;
        Modified := True;
      end;
    end;
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

  procedure TfMain.UpdateTree;
  var iRootCount: Integer;
  begin
     // If no project open
    if FLangSource=nil then begin
      tvMain.Hide;
      tvMain.Clear;
     // Else display the project in the tree
    end else begin
      tvMain.BeginUpdate;
      try
         // Number of root nodes equals to number of components
        iRootCount := FLangSource.ComponentSources.Count;
         // Plus 1 if constants present
        if FLangSource.Constants.Count>0 then Inc(iRootCount);
        tvMain.RootNodeCount := iRootCount;
         // Reinit whole tree
        tvMain.ReinitChildren(nil, True);
      finally
        tvMain.EndUpdate;
      end;
      tvMain.Show;
      tvMain.SetFocus;
    end;
    EnableActions;
  end;

end.
