unit udSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdSettings = class(TForm)
    pMain: TPanel;
    bOK: TButton;
    bCancel: TButton;
    lReposPath: TLabel;
    eReposPath: TEdit;
    bBrowseReposPath: TButton;
    cbRemovePrefix: TCheckBox;
    lRemovePrefix: TLabel;
    cbAutoAddStrings: TCheckBox;
    procedure bBrowseReposPathClick(Sender: TObject);
  private
  end;

  function EditSettings: Boolean;

implementation
{$R *.dfm}
uses ConsVars, FileCtrl;

  function EditSettings: Boolean;
  begin
    with TdSettings.Create(Application) do
      try
        eReposPath.Text := sTranRepositoryPath;
        cbRemovePrefix.Checked   := bReposRemovePrefix;
        cbAutoAddStrings.Checked := bReposAutoAddStrings;
        Result := ShowModal=mrOK;
        if Result then begin
          sTranRepositoryPath  := IncludeTrailingPathDelimiter(eReposPath.Text);
          bReposRemovePrefix   := cbRemovePrefix.Checked;
          bReposAutoAddStrings := cbAutoAddStrings.Checked;
        end;
      finally
        Free;
      end;
  end;

  procedure TdSettings.bBrowseReposPathClick(Sender: TObject);
  var s: String;
  begin
    s := ExcludeTrailingPathDelimiter(eReposPath.Text);
    if SelectDirectory(SDlgSelReposPath, '', s) then eReposPath.Text := IncludeTrailingPathDelimiter(s);
  end;

end.
