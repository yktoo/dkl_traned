unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DTLangTools, Dialogs, XPMan, ConsVars,
  Placemnt, ImgList, TB2Item, TB2MRU, TBXExtItems, ActnList, VirtualTrees,
  TBXStatusBars, TBX, TB2Dock, TB2Toolbar, ExtCtrls;

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
    dkTop: TTBXDock;
    dkBottom: TTBXDock;
    dkRight: TTBXDock;
    dkLeft: TTBXDock;
    tbMenu: TTBXToolbar;
    alMain: TActionList;
    aNew: TAction;
    aOpen: TAction;
    aSave: TAction;
    aSaveAs: TAction;
    aExit: TAction;
    smFile: TTBXSubmenuItem;
    smEdit: TTBXSubmenuItem;
    smView: TTBXSubmenuItem;
    smHelp: TTBXSubmenuItem;
    iExit: TTBXItem;
    iSaveAs: TTBXItem;
    iSave: TTBXItem;
    iOpen: TTBXItem;
    iNew: TTBXItem;
    iFileSep: TTBXSeparatorItem;
    iToggleStatusBar: TTBXVisibilityToggleItem;
    iToggleToolbar: TTBXVisibilityToggleItem;
    tbMain: TTBXToolbar;
    sbarMain: TTBXStatusBar;
    ilMain: TTBImageList;
    bSaveAs: TTBXItem;
    bSave: TTBXItem;
    bNew: TTBXItem;
    tbSep1: TTBXSeparatorItem;
    bExit: TTBXItem;
    iViewSep1: TTBXSeparatorItem;
    tbSep2: TTBXSeparatorItem;
    aAbout: TAction;
    iAbout: TTBXItem;
    bAbout: TTBXItem;
    aLangAdd: TAction;
    aLangRemove: TAction;
    iLangRemove: TTBXItem;
    iLangAdd: TTBXItem;
    bLangRemove: TTBXItem;
    bLangAdd: TTBXItem;
    aLangReplace: TAction;
    aSettings: TAction;
    aReposAddCurProp: TAction;
    aReposAddAllProps: TAction;
    iSettings: TTBXItem;
    iEditSep1: TTBXSeparatorItem;
    iReposAddAllProps: TTBXItem;
    iReposAddCurProp: TTBXItem;
    aReposAutoTranslate: TAction;
    iReposAutoTranslate: TTBXItem;
    bLangReplace: TTBXItem;
    iLangReplace: TTBXItem;
    aConstAdd: TAction;
    aConstDelete: TAction;
    aConstRename: TAction;
    iEditSep2: TTBXSeparatorItem;
    iConstRename: TTBXItem;
    iConstDelete: TTBXItem;
    iConstAdd: TTBXItem;
    smLanguage: TTBXSubmenuItem;
    tbSep3: TTBXSeparatorItem;
    bConstRename: TTBXItem;
    bConstDelete: TTBXItem;
    bConstAdd: TTBXItem;
    fpMain: TFormPlacement;
    bOpen: TTBXItem;
    pMain: TPanel;
    tvMain: TVirtualStringTree;
    aClose: TAction;
    iClose: TTBXItem;
    procedure aaOpen(Sender: TObject);
    procedure aaSave(Sender: TObject);
    procedure aaSaveAs(Sender: TObject);
    procedure aaExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure fpMainRestorePlacement(Sender: TObject);
    procedure fpMainSavePlacement(Sender: TObject);
    procedure aaAbout(Sender: TObject);
    procedure aaSettings(Sender: TObject);
    procedure tvMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tvMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure tvMainCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure tvMainKeyAction(Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure aaNew(Sender: TObject);
    procedure tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure aaClose(Sender: TObject);
  private
     // Language source storage
    FLangSource: TLangSource;
     // Loaded or new translations
    FTranslations: TDKLang_CompTranslations;
     // Prop storage
    FModified: Boolean;
    FFileName: String;
     // Redisplays the language source tree
    procedure UpdateTree;
     // Checks whether translation file is modified and asks to save it
    function  CheckSave: Boolean;
     // File loading/saving
    procedure DoLoad(const sLangSrcFileName, sTranFileName: String);
    procedure DoSave(const sFileName: String);
     // Updates form caption
    procedure UpdateCaption;
     // Adjusts Actions availability
    procedure EnableActions;
     // Closes all project data. If bUpdateDisplay=True, also updates the displayed items
    procedure CloseProject(bUpdateDisplay: Boolean);

     // Создаёт список пунктов меню переключения языка интерфейса
//    procedure LoadInterfaceLanguages;
     // App events
    procedure AppHint(Sender: TObject);
     // Prop handlers
    procedure SetModified(Value: Boolean);
    procedure SetFileName(const Value: String);
    function  GetDisplayFileName: String;
  public
     // Props
     // -- Displayed name of translation file currently open
    property DisplayFileName: String read GetDisplayFileName;
     // -- Name of the translation file currently open
    property FileName: String read FFileName write SetFileName;
     // -- True, if editor contents was saved since last save
    property Modified: Boolean read FModified write SetModified;
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses StdCtrls, Registry, udSelLang, udSettings, udAbout, udOpenFiles, udDiffLog;

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
     // Если TMemo, увеличиваем высоту
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

  procedure TfMain.aaNew(Sender: TObject);
  var sSourceFile, sTranFile: String;
  begin
    sSourceFile := '';
    sTranFile   := '';
    if SelectLangFiles(sSourceFile, sTranFile, True) then DoLoad(sSourceFile, '');
  end;

  procedure TfMain.aaOpen(Sender: TObject);
  var sSourceFile, sTranFile: String;
  begin
    sSourceFile := '';
    sTranFile   := '';
    if SelectLangFiles(sSourceFile, sTranFile, False) then DoLoad(sSourceFile, sTranFile);
  end;

  procedure TfMain.aaSave(Sender: TObject);
  begin
    if FFileName='' then aaSaveAs(Sender) else DoSave(FFileName);
  end;

  procedure TfMain.aaSaveAs(Sender: TObject);
  begin
    with TSaveDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := STranFileFilter;
        Options    := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
        Title      := SDlgTitle_SaveTranFileAs;
        FileName   := DisplayFileName;
        if Execute then DoSave(FileName);
      finally
        Free;
      end;
  end;

  procedure TfMain.aaSettings(Sender: TObject);
  begin
    EditSettings;
  end;

  procedure TfMain.AppHint(Sender: TObject);
  begin
    sbarMain.Panels[0].Caption := Application.Hint;
  end;

  function TfMain.CheckSave: Boolean;
  begin
    Result := not Modified;
    if not Result then
      case MessageBox(Handle, PChar(Format(SConfirm_FileNotSaved, [DisplayFileName])), PChar(SDlgTitle_Confirm), MB_ICONEXCLAMATION or MB_YESNOCANCEL) of
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
    FModified := False;
    FFileName := '';
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
      if sTranFileName<>'' then begin
        FTranslations.LoadFromFile(sTranFileName);
         // Now compare the source and the translation
        sDiff := FLangSource.CompareStructureWith(FTranslations);
        if sDiff<>'' then ShowDiffLog(sDiff);
      end;
       // Update properties
      FModified := False;
      FFileName := sTranFileName;
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
//    FRootComp.SaveToFile(sFileName);
//    FModified := False;
//    FFileName := sFileName;
//    UpdateCaption;
//    mruOpen.Add(FFileName);
  end;

  procedure TfMain.EnableActions;
  var bProject: Boolean;
//  var bComps, bNodeSel, bLangSel, bConstSel, bSomeLangs: Boolean;
  begin
    bProject := FLangSource<>nil;
//    bComps     := FRootComp.Name<>'';
//    bNodeSel   := tvMain.FocusedNode<>nil;
//    bLangSel   := CurLang<>$ffff;
//    bConstSel  := bNodeSel and (GetNodeKind(tvMain.FocusedNode)=nkConst);
//    bSomeLangs := FLangs.Count>1;
    aSave.Enabled               := bProject;
    aSaveAs.Enabled             := bProject;
    aClose.Enabled              := bProject;
//    aLangAdd.Enabled            := bComps;
//    aLangRemove.Enabled         := bLangSel;
//    aLangReplace.Enabled        := bLangSel;
//    aConstAdd.Enabled           := bComps;
//    aConstDelete.Enabled        := bConstSel;
//    aConstRename.Enabled        := bConstSel;
//    aReposAddCurProp.Enabled    := bSomeLangs;
//    aReposAddAllProps.Enabled   := bSomeLangs;
//    aReposAutoTranslate.Enabled := bSomeLangs and bLangSel;
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
//    mruOpen.LoadFromRegIni(fpMain.RegIniFile, SRegSection_OpenMRU);
//    with fpMain.RegIniFile do begin
//      dtlsMain.Language    := ReadInteger(SRegSection_Preferences, 'Language',            1033 {US English});
//      sTranRepositoryPath  := ReadString (SRegSection_Preferences, 'TranRepositoryPath',  ExtractFilePath(ParamStr(0)));
//      bReposRemovePrefix   := ReadBool   (SRegSection_Preferences, 'ReposRemovePrefix',   True);
//      bReposAutoAddStrings := ReadBool   (SRegSection_Preferences, 'ReposAutoAddStrings', True);
//    end;
//    if FileExists(sTranRepositoryPath+STranRepositoryFileName) then FTranRepository.LoadFromFile(sTranRepositoryPath+STranRepositoryFileName);
//    if ParamCount=0 then
//      aNew.Execute
//    else
//      DoLoad(ParamStr(1));
  end;

  procedure TfMain.fpMainSavePlacement(Sender: TObject);
  begin
    TBRegSavePositions(Self, HKEY_CURRENT_USER, SRegKey_Toolbars);
//    mruOpen.SaveToRegIni(fpMain.RegIniFile, SRegSection_OpenMRU);
//    with fpMain.RegIniFile do begin
//      WriteInteger(SRegSection_Preferences, 'Language',            dtlsMain.Language);
//      WriteString (SRegSection_Preferences, 'TranRepositoryPath',  sTranRepositoryPath);
//      WriteBool   (SRegSection_Preferences, 'ReposRemovePrefix',   bReposRemovePrefix);
//      WriteBool   (SRegSection_Preferences, 'ReposAutoAddStrings', bReposAutoAddStrings);
//    end;
//    FTranRepository.SaveToFile(sTranRepositoryPath+STranRepositoryFileName);
  end;

  function TfMain.GetDisplayFileName: String;
  begin
    Result := iif(FFileName='', STranFileDefaultName, FFileName);
  end;

//  procedure TfMain.LoadInterfaceLanguages;
//  var
//    Langs: TLanguages;
//    tbi: TTBItem;
//    i: Integer;
//  begin
//    Langs := TLanguages.Create;
//    try
//      dtlsMain.RootComp.BuildLangList(Langs, True, False);
//      for i := 0 to Langs.Count-1 do begin
//        tbi := TTBItem.Create(Self);
//        with tbi do begin
//          Caption    := Langs.Names[i];
//          Tag        := Langs[i];
//          Checked    := dtlsMain.Language=Tag;
//          GroupIndex := 1;
//          OnClick    := LanguageItemClick;
//        end;
//        smLanguage.Add(tbi);
//      end;
//    finally
//      Langs.Free;
//    end;
//  end;

  procedure TfMain.SetFileName(const Value: String);
  begin
    if FFileName<>Value then begin
      FFileName := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.SetModified(Value: Boolean);
  begin
    if FModified<>Value then begin
      FModified := Value;
      UpdateCaption;
    end;
  end;

  procedure TfMain.tvMainBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
  const aColors: Array[TNodeKind] of TColor = (0, $ffe5ec, clWindow, $eaeaff, $eaffea);
  begin
     // Paint the background depending on node kind
    ItemColor   := aColors[PNodeData(Sender.GetNodeData(Node)).Kind];
    EraseAction := eaColor;
  end;

  procedure TfMain.tvMainCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
  begin
//     // Имя константы редактируем стандартным редактором
//    if Column=0 then EditLink := TStringEditLink.Create else EditLink := TStrEditLinkEx.Create;
  end;

  procedure TfMain.tvMainEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
//  var nk: TNodeKind;
  begin
//    nk := GetNodeKind(Node);
//     // Можно редактировать только значение свойства и имя или значение константы
//    Allowed := ((nk=nkProp) and (Column>0)) or (nk=nkConst);
  end;

  procedure TfMain.tvMainFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  begin
    EnableActions;
  end;

  procedure TfMain.tvMainGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    if Column=0 then
      case PNodeData(Sender.GetNodeData(Node)).Kind of
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
              IColIdx_Original:   s := p.pSrcProp.sValue;
              IColIdx_Translated: if p.pTranProp<>nil then s := p.pTranProp.sValue;
            end;
          nkConsts: if Column=IColIdx_Name then s := SNode_Constants;
          nkConst:
            case Column of
              IColIdx_Name:       s := p.pSrcConst.sName;
              IColIdx_Original:   s := p.pSrcConst.sDefValue;
              IColIdx_Translated: if p.pTranConst<>nil then s := p.pTranConst.sDefValue;
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
//    if (Shift*[ssShift, ssAlt]=[]) and (CharCode=VK_RETURN) and not Sender.IsEditing then begin
//      DoDefault := False;
//      with Sender do
//        if FocusedNode<>nil then EditNode(FocusedNode, FocusedColumn);
//    end;
  end;

  procedure TfMain.tvMainNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
//  var
//    pte: TPropTranslationEntry;
//    wLang, wOrigLang: LANGID;
//    s: String;
  begin
//    s := NewText;
//    pte := PPropTranslationEntry(Sender.GetNodeData(Node))^;
//     // Если редактировали имя константы
//    if Column=0 then
//      pte.Name := s
//     // Иначе редактировали один из переводов
//    else begin
//       // Tag столбца - это ID его языка
//      wLang := ColToLang(Column);
//       // Запоминаем перевод
//      pte.Translations[wLang] := LineToMultiline(s);
//       // Добавляем перевод в репозиторий
//      if bReposAutoAddStrings and (FLangs.Count>1) then begin
//         // Если первый столбец, тогда оригиналом считаем второй столбец, иначе - первый
//        wOrigLang := ColToLang(iif(Column=1, 2, 1));
//        AddTranslation(pte.Translations[wOrigLang], s, wOrigLang, wLang);
//      end;
//    end;
//    Modified := True;
  end;

  procedure TfMain.tvMainPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  begin
     // Draw root nodes in bold
    if (TextType=ttNormal) and (Sender.NodeParent[Node]=nil) then TargetCanvas.Font.Style := [fsBold]; 
  end;

  procedure TfMain.UpdateCaption;
  const asMod: Array[Boolean] of String[1] = ('', '*');
  begin
    Caption := Format('[%s%s] - %s', [ExtractFileName(DisplayFileName), asMod[Modified], SAppCaption]);
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
    end;
    EnableActions;
  end;

end.
