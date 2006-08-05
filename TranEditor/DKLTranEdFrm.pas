unit DKLTranEdFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ConsVars,
  TntForms;

type
  TDKLTranEdForm = class(TTntForm)
     // Event handler of type TNotifyEvent for binding in derived forms 
    procedure ShowHelpNotify(Sender: TObject);
  private
     // Message handlers
    procedure WMHelp(var Msg: TWMHelp); message WM_HELP;
  protected
     // Invokes context help, or help contents if context is not specified
    procedure ShowHelp;
     // Modal showing initialize routine
    procedure ExecuteInitialize; virtual;
     // Modal showing finalize routine
    procedure ExecuteFinalize; virtual;
  public
     // Shows the form modally. Returns True if ModalResult=mrOK
    function  ExecuteModal: Boolean;
  end;

implementation
{$R *.dfm}
uses ChmHlp;

  procedure TDKLTranEdForm.ExecuteFinalize;
  begin
    { does nothing }
  end;

  procedure TDKLTranEdForm.ExecuteInitialize;
  begin
    { does nothing }
  end;

  function TDKLTranEdForm.ExecuteModal: Boolean;
  begin
    try
      ExecuteInitialize;
      Result := ShowModal=mrOk;
    finally
      ExecuteFinalize;
    end;
  end;

  procedure TDKLTranEdForm.ShowHelp;
  begin
    if HelpContext<=0 then
      HtmlHelp(0, SHelpFileName, HH_DISPLAY_TOC, 0)
    else
      HtmlHelp(0, SHelpFileName, HH_HELP_CONTEXT, Cardinal(HelpContext));
  end;

  procedure TDKLTranEdForm.ShowHelpNotify(Sender: TObject);
  begin
    ShowHelp;
  end;

  procedure TDKLTranEdForm.WMHelp(var Msg: TWMHelp);
  begin
     // Ignore Shift/Ctrl/Alt+F1 hit
    if ((GetKeyState(VK_SHIFT) or GetKeyState(VK_CONTROL) or GetKeyState(VK_MENU)) and $80=0) and
        (Msg.HelpInfo.iContextType=HELPINFO_WINDOW) then ShowHelp;
  end;

end.

