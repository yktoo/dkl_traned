unit udTranProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DKLang,
  StdCtrls, ExtCtrls;

type
  TdTranProps = class(TForm)
    pMain: TPanel;
    bOK: TButton;
    bCancel: TButton;
    lLang: TLabel;
    cbLang: TComboBox;
    lAuthor: TLabel;
    eAuthor: TEdit;
    procedure bOKClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
  private
     // The translations which properties are to edit
    FTranslations: TDKLang_CompTranslations;
     // Loads the language list into cbLang
    procedure LoadLanguages;
  protected
    procedure InitializeDialog;
    function  Execute: Boolean;
  end;

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations): Boolean;
  begin
    with TdTranProps.Create(Application) do
      try
        FTranslations := ATranslations;
        Result := Execute;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdTranProps
   //===================================================================================================================

  procedure TdTranProps.AdjustOKCancel(Sender: TObject);
  begin
    bOK.Enabled := (cbLang.ItemIndex>=0);
  end;

  procedure TdTranProps.bOKClick(Sender: TObject);
  begin
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_LangID] := IntToStr(Integer(cbLang.Items.Objects[cbLang.ItemIndex]));
      Values[SDKLang_TranParam_Author] := eAuthor.Text;
    end;
    ModalResult := mrOK;
  end;

  function TdTranProps.Execute: Boolean;
  begin
    InitializeDialog;
    Result := ShowModal=mrOK;
  end;

  procedure TdTranProps.InitializeDialog;
  begin
    LoadLanguages;
    with FTranslations.Params do begin
      cbLang.ItemIndex := cbLang.Items.IndexOfObject(Pointer(StrToIntDef(Values[SDKLang_TranParam_LangID], -1)));
      eAuthor.Text     := Values[SDKLang_TranParam_Author];
    end;
    AdjustOKCancel(nil);  
  end;

  procedure TdTranProps.LoadLanguages;
  var
    i: Integer;
    L: LCID;
  begin
    for i := 0 to Languages.Count-1 do begin
      L := Languages.LocaleID[i];
      if L and $ffff0000=0 then cbLang.AddItem(Languages.Name[i], Pointer(L));
    end;
  end;

end.
