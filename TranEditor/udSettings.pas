//**********************************************************************************************************************
//  $Id: udSettings.pas,v 1.12 2006-09-13 14:38:06 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, TntSystem, TntWindows,
  TntSysUtils, uTranEdPlugin, ConsVars,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls,
  VirtualTrees, ExtCtrls, TntExtCtrls;

type
  TdSettings = class(TDKLTranEdForm)
    bBrowseReposPath: TTntButton;
    bCancel: TTntButton;
    bHelp: TTntButton;
    bInterfaceFont: TTntButton;
    bOK: TTntButton;
    bTableFont: TTntButton;
    cbAutoAddStrings: TTntCheckBox;
    cbIgnoreEncodingMismatch: TTntCheckBox;
    cbRemovePrefix: TTntCheckBox;
    dklcMain: TDKLanguageController;
    eReposPath: TTntEdit;
    gbInterface: TGroupBox;
    gbRepository: TGroupBox;
    lInterfaceFont: TTntLabel;
    lRemovePrefix: TTntLabel;
    lReposPath: TTntLabel;
    lTableFont: TTntLabel;
    pcMain: TTntPageControl;
    tsGeneral: TTntTabSheet;
    tsPlugins: TTntTabSheet;
    tvPlugins: TVirtualStringTree;
    procedure AdjustOKCancel(Sender: TObject);
    procedure bBrowseReposPathClick(Sender: TObject);
    procedure bInterfaceFontClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bTableFontClick(Sender: TObject);
    procedure tvPluginsBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure tvPluginsExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure tvPluginsGetCursor(Sender: TBaseVirtualTree; var Cursor: TCursor);
    procedure tvPluginsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvPluginsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure tvPluginsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure tvPluginsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvPluginsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
     // Fonts
    FInterfaceFont: WideString;
    FTableFont: WideString;
     // Plugin host object
    FPluginHost: TPluginHost;
     // Returns True if point p (client coordinates) is at hyperlink in tvPlugins
    function  PointAtPluginHyperlink(const p: TPoint; out Plugin: IDKLang_TranEd_Plugin): Boolean;
     // Updates info about selected fonts
    procedure UpdateFonts;
  protected
    procedure DoCreate; override;
    procedure ExecuteInitialize; override;
  end;

  function EditSettings(APluginHost: TPluginHost): Boolean;

implementation
{$R *.dfm}
uses TntFileCtrl, ShellAPI, Main;

const
   // tvPlugins column indices
  IColIdx_Plugins_Name            = 0;
  IColIdx_Plugins_Value           = 1;
   // Number of plugin info entries
  IPluginInfoEntryCount           = 5;
   // Plugin info entries indices
  IPluginInfoEntryIdx_Version     = 0;
  IPluginInfoEntryIdx_Author      = 1;
  IPluginInfoEntryIdx_Copyright   = 2;
  IPluginInfoEntryIdx_Description = 3;
  IPluginInfoEntryIdx_Website     = 4;

  function EditSettings(APluginHost: TPluginHost): Boolean;
  begin
    with TdSettings.Create(Application) do
      try
        FPluginHost := APluginHost;
        Result := ExecuteModal;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdSettings
   //===================================================================================================================

  procedure TdSettings.AdjustOKCancel(Sender: TObject);
  begin
    bOK.Enabled := True;
  end;

  procedure TdSettings.bBrowseReposPathClick(Sender: TObject);
  var ws: WideString;
  begin
    ws := eReposPath.Text;
    if WideSelectDirectory(DKLangConstW('SDlgTitle_SelReposPath'), '', ws) then eReposPath.Text := ws;
  end;

  procedure TdSettings.bInterfaceFontClick(Sender: TObject);
  begin
    if SelectFont(FInterfaceFont) then begin
      UpdateFonts;
      AdjustOKCancel(nil);
    end;
  end;

  procedure TdSettings.bOKClick(Sender: TObject);
  begin
     // Repository
    wsSetting_RepositoryDir         := eReposPath.Text;
    bSetting_ReposRemovePrefix      := cbRemovePrefix.Checked;
    bSetting_ReposAutoAdd           := cbAutoAddStrings.Checked;
     // Interface
    wsSetting_InterfaceFont         := FInterfaceFont;
    wsSetting_TableFont             := FTableFont;
     // Misc
    bSetting_IgnoreEncodingMismatch := cbIgnoreEncodingMismatch.Checked; 
    ModalResult := mrOK;
  end;

  procedure TdSettings.bTableFontClick(Sender: TObject);
  begin
    if SelectFont(FTableFont) then begin
      UpdateFonts;
      AdjustOKCancel(nil);
    end;
  end;

  procedure TdSettings.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_settings;
  end;

  procedure TdSettings.ExecuteInitialize;
  begin
    inherited ExecuteInitialize;
    pcMain.ActivePageIndex := 0;
     // Repository
    eReposPath.Text                  := wsSetting_RepositoryDir;
    cbRemovePrefix.Checked           := bSetting_ReposRemovePrefix;
    cbAutoAddStrings.Checked         := bSetting_ReposAutoAdd;
     // Interface
    FInterfaceFont                   := wsSetting_InterfaceFont;
    FTableFont                       := wsSetting_TableFont;
    UpdateFonts;
     // Misc
    cbIgnoreEncodingMismatch.Checked := bSetting_IgnoreEncodingMismatch;
     // Plugins
    tvPlugins.RootNodeCount          := FPluginHost.PluginEntryCount;
  end;

  function TdSettings.PointAtPluginHyperlink(const p: TPoint; out Plugin: IDKLang_TranEd_Plugin): Boolean;
  var hi: THitInfo;
  begin
    tvPlugins.GetHitTestInfoAt(p.x, p.y, True, hi);
    Result :=
      (hi.HitNode<>nil) and (tvPlugins.NodeParent[hi.HitNode]<>nil) and (hi.HitColumn=IColIdx_Plugins_Value) and
      (hiOnItemLabel in hi.HitPositions) and (hi.HitNode.Index=IPluginInfoEntryIdx_Website);
    if Result then Plugin := FPluginHost[tvPlugins.NodeParent[hi.HitNode].Index].Plugin else Plugin := nil;
  end;

  procedure TdSettings.tvPluginsBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
  begin
     // Shade plugin rows
    if Sender.NodeParent[Node]=nil then begin
      EraseAction := eaColor;
      ItemColor   := CBack_LightShade;
    end;
  end;

  procedure TdSettings.tvPluginsExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
  begin
    if Sender.ChildCount[Node]=0 then Sender.ChildCount[Node] := IPluginInfoEntryCount;
  end;

  procedure TdSettings.tvPluginsGetCursor(Sender: TBaseVirtualTree; var Cursor: TCursor);
  var Plugin: IDKLang_TranEd_Plugin;
  begin
    if PointAtPluginHyperlink(Sender.ScreenToClient(Mouse.CursorPos), Plugin) then Cursor := crHandPoint;
  end;

  procedure TdSettings.tvPluginsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  begin
    if (Kind in [ikNormal, ikSelected]) and (Sender.NodeParent[Node]=nil) and (Column=IColIdx_Plugins_Name) then
      ImageIndex := iiPlugin;
  end;

  procedure TdSettings.tvPluginsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  var
    cEntryIndex: Cardinal;
    PE: TPluginEntry;
    PI: IDKLang_TranEd_PluginInfo;
    nParent: PVirtualNode;
  begin
    if TextType<>ttNormal then Exit;
    nParent := Sender.NodeParent[Node];
    if nParent=nil then cEntryIndex := Node.Index else cEntryIndex := nParent.Index;
    PE := FPluginHost[cEntryIndex];
     // Root node
    if nParent=nil then
      case Column of
        IColIdx_Plugins_Name:  CellText := PE.Plugin.Name;
        IColIdx_Plugins_Value: CellText := PE.FileName;
      end
     // Child node
    else
      case Column of
        IColIdx_Plugins_Name:
          case Node.Index of
            IPluginInfoEntryIdx_Version:     CellText := DKLangConstW('SMsg_PluginVersion');
            IPluginInfoEntryIdx_Author:      CellText := DKLangConstW('SMsg_PluginAuthor');
            IPluginInfoEntryIdx_Copyright:   CellText := DKLangConstW('SMsg_PluginCopyright');
            IPluginInfoEntryIdx_Description: CellText := DKLangConstW('SMsg_PluginDescription');
            IPluginInfoEntryIdx_Website:     CellText := DKLangConstW('SMsg_PluginWebsite');
          end;
        IColIdx_Plugins_Value:
          if Supports(PE.Plugin, IDKLang_TranEd_PluginInfo, PI) then
            case Node.Index of
              IPluginInfoEntryIdx_Version:     CellText := WideFormat('%s (%d)', [PI.InfoVersionText, PE.SubsystemVersion]);
              IPluginInfoEntryIdx_Author:      CellText := PI.InfoAuthor;
              IPluginInfoEntryIdx_Copyright:   CellText := PI.InfoCopyright;
              IPluginInfoEntryIdx_Description: CellText := PI.InfoDescription;
              IPluginInfoEntryIdx_Website:     CellText := PI.InfoWebsiteURL;
            end;
      end;
  end;

  procedure TdSettings.tvPluginsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  begin
     // Mark the node as having children if there's extended plugin info
    if (ParentNode=nil) and Supports(FPluginHost[Node.Index].Plugin, IDKLang_TranEd_PluginInfo) then
      Include(InitialStates, ivsHasChildren);
  end;

  procedure TdSettings.tvPluginsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var Plugin: IDKLang_TranEd_Plugin;
  begin
     // When plugin's URL clicked open it
    if (Shift=[ssLeft]) and PointAtPluginHyperlink(Point(x, y), Plugin) then
      Tnt_ShellExecuteW(
        Application.Handle,
        nil,
        PWideChar((Plugin as IDKLang_TranEd_PluginInfo).InfoWebsiteURL),
        nil,
        nil,
        SW_SHOWNORMAL);
  end;

  procedure TdSettings.tvPluginsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  begin
     // Draw plugin names in bold
    if Sender.NodeParent[Node]=nil then begin
      if Column=IColIdx_Plugins_Name then TargetCanvas.Font.Style := [fsBold];
     // Draw URLs as hyperlinks
    end else
      if (Column=IColIdx_Plugins_Value) and (Node.Index=IPluginInfoEntryIdx_Website) then begin
        TargetCanvas.Font.Style := [fsUnderline];
        if not (vsSelected in Node.States) then TargetCanvas.Font.Color := clHotLight;
      end;
  end;

  procedure TdSettings.UpdateFonts;

    procedure ShowFont(const wsFont: WideString; Lbl: TTntLabel);
    begin
      Lbl.Caption := GetFirstWord(wsFont, '/');
      FontFromStr(Lbl.Font, wsFont);
    end;

  begin
    ShowFont(FInterfaceFont, lInterfaceFont);
    ShowFont(FTableFont,     lTableFont);
  end;

end.


