//**********************************************************************************************************************
//  $Id: udDiffLog.pas,v 1.7 2006-06-17 04:19:28 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udDiffLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DKLang;

type
  TdDiffLog = class(TForm)
    bClose: TButton;
    mMain: TMemo;
    gbTotals: TGroupBox;
    lbTotals: TListBox;
    cbAutoTranslate: TCheckBox;
    dklcMain: TDKLanguageController;
    procedure mMainKeyPress(Sender: TObject; var Key: Char);
  end;

   // Show the window displaying the difference log
  procedure ShowDiffLog(const sLog: String; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer; out bAutoTranslate: Boolean);

implementation
{$R *.dfm}
uses ConsVars;

  procedure ShowDiffLog(const sLog: String; iCntAddedComps, iCntAddedProps, iCntAddedConsts, iCntRemovedComps, iCntRemovedProps, iCntRemovedConsts, iCntComps, iCntProps, iCntConsts: Integer; out bAutoTranslate: Boolean);
  begin
    with TdDiffLog.Create(Application) do
      try
        mMain.Text := sLog;
        lbTotals.Items.Text := Format(
          ConstVal('SDiffTotalsText'),
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

  procedure TdDiffLog.mMainKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key=#27 then Close; 
  end;

end.
