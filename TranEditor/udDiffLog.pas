unit udDiffLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdDiffLog = class(TForm)
    bClose: TButton;
    mMain: TMemo;
    procedure mMainKeyPress(Sender: TObject; var Key: Char);
  end;

   // Show the window displaying the difference log
  procedure ShowDiffLog(const sLog: String);

implementation
{$R *.dfm}

  procedure ShowDiffLog(const sLog: String);
  begin
    with TdDiffLog.Create(Application) do
      try
        mMain.Text := sLog;
        ShowModal;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdDiffLog
   //===================================================================================================================

  procedure TdDiffLog.mMainKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key=#27 then Close; 
  end;

end.
