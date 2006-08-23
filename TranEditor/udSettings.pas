//**********************************************************************************************************************
//  $Id: udSettings.pas,v 1.9 2006-08-23 15:19:11 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls;

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
    procedure AdjustOKCancel(Sender: TObject);
    procedure bBrowseReposPathClick(Sender: TObject);
    procedure bInterfaceFontClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bTableFontClick(Sender: TObject);
  private
     // Fonts
    FInterfaceFont: WideString;
    FTableFont: WideString;
     // Updates info about selected fonts
    procedure UpdateFonts;
  protected
    procedure DoCreate; override;
    procedure ExecuteInitialize; override;
  end;

  function EditSettings: Boolean;

implementation
{$R *.dfm}
uses ConsVars, TntFileCtrl;

  function EditSettings: Boolean;
  begin
    with TdSettings.Create(Application) do
      try
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


