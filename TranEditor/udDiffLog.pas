//**********************************************************************************************************************
//  $Id: udDiffLog.pas,v 1.9 2006-08-23 15:19:11 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udDiffLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls;

type
  TdDiffLog = class(TDKLTranEdForm)
    bClose: TTntButton;
    bHelp: TTntButton;
    cbAutoTranslate: TTntCheckBox;
    dklcMain: TDKLanguageController;
    gbTotals: TTntGroupBox;
    lbTotals: TTntListBox;
    mMain: TTntMemo;
    procedure mMainKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure DoCreate; override;
  end;

   // Show the window displaying the difference log
  procedure ShowDiffLog(const wsLog: WideString; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer; out bAutoTranslate: Boolean);

implementation
{$R *.dfm}
uses ConsVars;

  procedure ShowDiffLog(const wsLog: WideString; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer; out bAutoTranslate: Boolean);
  begin
    with TdDiffLog.Create(Application) do
      try
        mMain.Text := wsLog;
        lbTotals.Items.Text := WideFormat(
          DKLangConstW('SDiffTotalsText'),
          [iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts]);
        cbAutoTranslate.Enabled := iCntAddedProps+iCntAddedConsts>0;
        ShowModal;
        bAutoTranslate := cbAutoTranslate.Checked;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdDiffLog
   //===================================================================================================================

  procedure TdDiffLog.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_diff_log;
  end;

  procedure TdDiffLog.mMainKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key=#27 then Close; 
  end;

end.


