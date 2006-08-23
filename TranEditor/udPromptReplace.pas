//**********************************************************************************************************************
//  $Id: udPromptReplace.pas,v 1.5 2006-08-23 15:19:11 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udPromptReplace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls;

type
  TdPromptReplace = class(TDKLTranEdForm)
    bCancel: TTntButton;
    bHelp: TTntButton;
    bNo: TTntButton;
    bReplaceAll: TTntButton;
    bYes: TTntButton;
    dklcMain: TDKLanguageController;
    lMessage: TTntLabel;
    mText: TTntMemo;
  protected
    procedure DoCreate; override;
  end;

   // Shows the Confirm replace dialog. rSnap is the rectangle of the corresponding item, in screen coordinates
  function PromptForReplace(const wsSourceText, wsSearchPattern: WideString; iMatchPos: Integer; const rSnap: TRect): TModalResult;

implementation
{$R *.dfm}
uses ConsVars;

  function PromptForReplace(const wsSourceText, wsSearchPattern: WideString; iMatchPos: Integer; const rSnap: TRect): TModalResult;
  var iTop: Integer;
  begin
    with TdPromptReplace.Create(Application) do
      try
        lMessage.Caption := DKLangConstW('SMsg_PromptReplace', [wsSearchPattern]);
        mText.Text      := wsSourceText;
        mText.SelStart  := iMatchPos-1;
        mText.SelLength := Length(wsSearchPattern);
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

{ TdPromptReplace }

  procedure TdPromptReplace.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_prompt_replace;
  end;

end.


