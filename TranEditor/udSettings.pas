unit udSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

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
          sTranRepositoryPath  := IncludeTrailingPathDelimiter(eReposPath.Text);
          bReposRemovePrefix   := cbRemovePrefix.Checked;
          bReposAutoAddStrings := cbAutoAddStrings.Checked;
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
    s := ExcludeTrailingPathDelimiter(eReposPath.Text);
    if SelectDirectory(SDlgSelReposPath, '', s) then eReposPath.Text := IncludeTrailingPathDelimiter(s);
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
    eReposPath.Text := sTranRepositoryPath;
    cbRemovePrefix.Checked   := bReposRemovePrefix;
    cbAutoAddStrings.Checked := bReposAutoAddStrings;
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
