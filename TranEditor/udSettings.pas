//**********************************************************************************************************************
//  $Id: udSettings.pas,v 1.7 2006-06-17 04:19:28 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, DKLang;

type
  TdSettings = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    pcMain: TPageControl;
    tsRepository: TTabSheet;
    tsInterface: TTabSheet;
    lReposPath: TLabel;
    lRemovePrefix: TLabel;
    eReposPath: TEdit;
    bBrowseReposPath: TButton;
    cbRemovePrefix: TCheckBox;
    cbAutoAddStrings: TCheckBox;
    bInterfaceFont: TButton;
    bTableFont: TButton;
    lInterfaceFont: TLabel;
    lTableFont: TLabel;
    dklcMain: TDKLanguageController;
    procedure bBrowseReposPathClick(Sender: TObject);
    procedure bInterfaceFontClick(Sender: TObject);
    procedure bTableFontClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
    procedure bOKClick(Sender: TObject);
  private
     // Fonts
    FInterfaceFont: String;
    FTableFont: String;
     // Updates info about selected fonts
    procedure UpdateFonts;
  protected
    procedure InitializeDialog;
    procedure FinalizeDialog;
    function  Execute: Boolean;
  end;

  function EditSettings: Boolean;

implementation
{$R *.dfm}
uses ConsVars, FileCtrl;

  function EditSettings: Boolean;
  begin
    with TdSettings.Create(Application) do
      try
        Result := Execute;
        if Result then begin
          bSetting_ReposRemovePrefix := cbRemovePrefix.Checked;
          bSetting_ReposAutoAdd      := cbAutoAddStrings.Checked;
        end;
      finally
        Free;
      end;
  end;

  procedure TdSettings.AdjustOKCancel(Sender: TObject);
  begin
    bOK.Enabled := True;
  end;

  procedure TdSettings.bBrowseReposPathClick(Sender: TObject);
  var s: String;
  begin
    s := eReposPath.Text;
    if SelectDirectory(ConstVal('SDlgTitle_SelReposPath'), '', s) then eReposPath.Text := s;
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
    sSetting_RepositoryDir := eReposPath.Text;
     // Interface
    sSetting_InterfaceFont := FInterfaceFont;
    sSetting_TableFont     := FTableFont;
    ModalResult := mrOK;
  end;

  procedure TdSettings.bTableFontClick(Sender: TObject);
  begin
    if SelectFont(FTableFont) then begin
      UpdateFonts;
      AdjustOKCancel(nil);
    end;
  end;

  function TdSettings.Execute: Boolean;
  begin
    try
      InitializeDialog;
      Result := ShowModal=mrOK;
    finally
      FinalizeDialog;
    end;
  end;

  procedure TdSettings.FinalizeDialog;
  begin
    { does nothing }
  end;

  procedure TdSettings.InitializeDialog;
  begin
     // Repository
    eReposPath.Text          := sSetting_RepositoryDir;
    cbRemovePrefix.Checked   := bSetting_ReposRemovePrefix;
    cbAutoAddStrings.Checked := bSetting_ReposAutoAdd;
     // Interface
    FInterfaceFont := sSetting_InterfaceFont;
    FTableFont     := sSetting_TableFont;
    UpdateFonts;
    pcMain.ActivePageIndex := 0;
  end;

  procedure TdSettings.UpdateFonts;

    procedure ShowFont(const sFont: String; Lbl: TLabel);
    begin
      Lbl.Caption := GetFirstWord(sFont, '/');
      FontFromStr(Lbl.Font, sFont);
    end;

  begin
    ShowFont(FInterfaceFont, lInterfaceFont);
    ShowFont(FTableFont,     lTableFont);
  end;

end.
