//**********************************************************************************************************************
//  $Id: udDiffLog.pas,v 1.4 2004-09-11 17:58:01 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org/
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
          StringReplace(ConstVal('SDiffTotalsText'), ';', #9, [rfReplaceAll]),
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
