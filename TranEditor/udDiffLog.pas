unit udDiffLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdDiffLog = class(TForm)
    bClose: TButton;
    mMain: TMemo;
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

end.
