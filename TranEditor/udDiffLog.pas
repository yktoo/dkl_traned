unit udDiffLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdDiffLog = class(TForm)
    bClose: TButton;
    mMain: TMemo;
    gbTotals: TGroupBox;
    lbTotals: TListBox;
    cbAutoTranslate: TCheckBox;
    procedure mMainKeyPress(Sender: TObject; var Key: Char);
  end;

   // Show the window displaying the difference log
  procedure ShowDiffLog(const sLog: String; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts: Integer; out bAutoTranslate: Boolean);

implementation
{$R *.dfm}
uses ConsVars;

  procedure ShowDiffLog(const sLog: String; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts: Integer; out bAutoTranslate: Boolean);
  begin
    with TdDiffLog.Create(Application) do
      try
        mMain.Text := sLog;
        lbTotals.Items.Text := Format(
          SDiffTotalsText,
          [iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts]);
        ShowModal;
        bAutoTranslate := cbAutoTranslate.Checked;
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
