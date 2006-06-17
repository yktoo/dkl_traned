//**********************************************************************************************************************
//  $Id: udPromptReplace.pas,v 1.3 2006-06-17 04:19:28 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udPromptReplace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DKLang;

type
  TdPromptReplace = class(TForm)
    bCancel: TButton;
    bNo: TButton;
    bReplaceAll: TButton;
    bYes: TButton;
    dklcMain: TDKLanguageController;
    lMessage: TLabel;
    mText: TMemo;
  end;

   // Shows the Confirm replace dialog. rSnap is the rectangle of the corresponding item, in screen coordinates
  function PromptForReplace(const sSourceText, sSearchPattern: String; iMatchPos: Integer; const rSnap: TRect): TModalResult;

implementation
{$R *.dfm}
uses ConsVars;

  function PromptForReplace(const sSourceText, sSearchPattern: String; iMatchPos: Integer; const rSnap: TRect): TModalResult;
  var iTop: Integer;
  begin
    with TdPromptReplace.Create(Application) do
      try
        lMessage.Caption := ConstVal('SMsg_PromptReplace', [sSearchPattern]);
        mText.Text      := sSourceText;
        mText.SelStart  := iMatchPos-1;
        mText.SelLength := Length(sSearchPattern);
         // Position the window
        iTop := rSnap.Top-Height;
        if iTop<=Screen.WorkAreaTop then iTop := rSnap.Bottom;
        SetBounds((rSnap.Left+rSnap.Right-Width) div 2, iTop, Width, Height);
         // Show
        Result := ShowModal;
      finally
        Free;
      end;
  end;

end.
