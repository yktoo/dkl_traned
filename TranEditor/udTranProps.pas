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
    lAdditionalParams: TLabel;
    mAdditionalParams: TMemo;
    lTargetApp: TLabel;
    cbTargetApp: TComboBox;
    procedure bOKClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
  private
     // The translations which properties are to edit
    FTranslations: TDKLang_CompTranslations;
     // MRU strings for Target Application
    FTargetAppMRUStrings: TStrings;
     // Loads the language list into cbLang
    procedure LoadLanguages;
  protected
    procedure InitializeDialog;
    function  Execute: Boolean;
  end;

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations; TargetAppMRUStrings: TStrings): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

const
   // Params considered to be known (they not appear in 'Additional parameters' list)
  asKnownParams: Array[0..4] of String = (
    SDKLang_TranParam_LangID,
    SDKLang_TranParam_Author,
    SDKLang_TranParam_Generator,
    SDKLang_TranParam_LastModified,
    SDKLang_TranParam_TargetApplication);

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations; TargetAppMRUStrings: TStrings): Boolean;
  begin
    with TdTranProps.Create(Application) do
      try
        FTranslations        := ATranslations;
        FTargetAppMRUStrings := TargetAppMRUStrings;
        Result := Execute;
      finally
        Free;
      end;
  end;

   // Returns True if parameter is in asKnownParams[]
  function ParamKnown(const sParam: String): Boolean;
  var i: Integer;
  begin
    for i := 0 to High(asKnownParams) do
      if AnsiSameText(sParam, asKnownParams[i]) then begin
        Result := True;
        Exit;
      end;
    Result := False;
  end;
  
   //===================================================================================================================
   // TdTranProps
   //===================================================================================================================

  procedure TdTranProps.AdjustOKCancel(Sender: TObject);
  begin
    if Visible then bOK.Enabled := (cbLang.ItemIndex>=0);
  end;

  procedure TdTranProps.bOKClick(Sender: TObject);
  var i: Integer;
  begin
    FTranslations.Params.Clear;
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_LangID]            := IntToStr(Integer(cbLang.Items.Objects[cbLang.ItemIndex]));
      Values[SDKLang_TranParam_TargetApplication] := cbTargetApp.Text;
      Values[SDKLang_TranParam_Author]            := eAuthor.Text;
    end;
     // Fill additional parameters
    for i := 0 to mAdditionalParams.Lines.Count-1 do
      if not ParamKnown(mAdditionalParams.Lines.Names[i]) then FTranslations.Params.Add(mAdditionalParams.Lines[i]);
     // Update MRU
    FTargetAppMRUStrings.Add(cbTargetApp.Text);  
    ModalResult := mrOK;
  end;

  function TdTranProps.Execute: Boolean;
  begin
    InitializeDialog;
    Result := ShowModal=mrOK;
  end;

  procedure TdTranProps.InitializeDialog;
  var i: Integer;
  begin
    LoadLanguages;
    cbTargetApp.Items.Assign(FTargetAppMRUStrings);
    with FTranslations.Params do begin
      cbLang.ItemIndex := cbLang.Items.IndexOfObject(Pointer(StrToIntDef(Values[SDKLang_TranParam_LangID], -1)));
      cbTargetApp.Text := Values[SDKLang_TranParam_TargetApplication];
      eAuthor.Text     := Values[SDKLang_TranParam_Author];
    end;
     // Fill additional parameters
    for i := 0 to FTranslations.Params.Count-1 do
      if not ParamKnown(FTranslations.Params.Names[i]) then mAdditionalParams.Lines.Add(FTranslations.Params[i]);
    AdjustOKCancel(nil);
  end;

  procedure TdTranProps.LoadLanguages;
  var
    i: Integer;
    L: LCID;
  begin
    for i := 0 to Languages.Count-1 do begin
      L := Languages.LocaleID[i];
      if L and $ffff0000=0 then cbLang.AddItem(Format('%.5d - 0x%0:.4x - %s', [L, Languages.Name[i]]), Pointer(L));
    end;
  end;

end.
