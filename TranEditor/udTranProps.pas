//**********************************************************************************************************************
//  $Id: udTranProps.pas,v 1.8 2006-06-17 04:19:28 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udTranProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DKLang,
  StdCtrls, ExtCtrls, TB2MRU;

type
  TdTranProps = class(TForm)
    pMain: TPanel;
    bOK: TButton;
    bCancel: TButton;
    lTranLang: TLabel;
    cbTranLang: TComboBox;
    lAuthor: TLabel;
    eAuthor: TEdit;
    lAdditionalParams: TLabel;
    mAdditionalParams: TMemo;
    lTargetApp: TLabel;
    cbTargetApp: TComboBox;
    MRUTargetApp: TTBMRUList;
    lSrcLang: TLabel;
    cbSrcLang: TComboBox;
    dklcMain: TDKLanguageController;
    procedure bOKClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
  private
     // The translations which properties are to edit
    FTranslations: TDKLang_CompTranslations;
     // Source and target LangIDs
    FSrcLangID: LANGID;
    FTranLangID: LANGID;
     // Loads the language list into cbLang
    procedure LoadLanguages;
  protected
    procedure InitializeDialog;
    procedure FinalizeDialog;
    function  Execute: Boolean;
  end;

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations; var wSrcLangID, wTranLangID: LANGID): Boolean;

implementation
{$R *.dfm}
uses Registry, ConsVars;

const
   // Params considered to be known (they do not appear in 'Additional parameters' list)
  asKnownParams: Array[0..5] of String = (
    SDKLang_TranParam_LangID,
    SDKLang_TranParam_SourceLangID,
    SDKLang_TranParam_Author,
    SDKLang_TranParam_Generator,
    SDKLang_TranParam_LastModified,
    SDKLang_TranParam_TargetApplication);

  function EditTranslationProps(ATranslations: TDKLang_CompTranslations; var wSrcLangID, wTranLangID: LANGID): Boolean;
  begin
    with TdTranProps.Create(Application) do
      try
        FTranslations := ATranslations;
        FSrcLangID    := wSrcLangID;
        FTranLangID   := wTranLangID;
        Result := Execute;
        if Result then begin
          wSrcLangID  := FSrcLangID;
          wTranLangID := FTranLangID;
        end;
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
    if Visible then bOK.Enabled := (cbSrcLang.ItemIndex>=0) and (cbTranLang.ItemIndex>=0);
  end;

  procedure TdTranProps.bOKClick(Sender: TObject);
  var i: Integer;
  begin
     // Get LangIDs
    FSrcLangID  := GetCBObject(cbSrcLang);
    FTranLangID := GetCBObject(cbTranLang);
    if FSrcLangID=FTranLangID then TranEdError(ConstVal('SErrMsg_SrcAndTranLangsAreSame'));
     // Update translation params
    FTranslations.Params.Clear;
    with FTranslations.Params do begin
      Values[SDKLang_TranParam_TargetApplication] := cbTargetApp.Text;
      Values[SDKLang_TranParam_Author]            := eAuthor.Text;
    end;
     // Fill additional parameters
    for i := 0 to mAdditionalParams.Lines.Count-1 do
      if not ParamKnown(mAdditionalParams.Lines.Names[i]) then FTranslations.Params.Add(mAdditionalParams.Lines[i]);
     // Update MRU
    MRUTargetApp.Add(cbTargetApp.Text);
    ModalResult := mrOK;
  end;

  function TdTranProps.Execute: Boolean;
  begin
    try
      InitializeDialog;
      Result := ShowModal=mrOK;
    finally
      FinalizeDialog;
    end;
  end;

  procedure TdTranProps.FinalizeDialog;
  var rif: TRegIniFile;
  begin
     // Save settings
    rif := TRegIniFile.Create(SRegKey_Root);
    try
      MRUTargetApp.SaveToRegIni(rif, SRegSection_MRUTargetApp);
    finally
      rif.Free;
    end;
  end;

  procedure TdTranProps.InitializeDialog;
  var
    i: Integer;
    rif: TRegIniFile;
  begin
     // Load settings
    rif := TRegIniFile.Create(SRegKey_Root);
    try
      MRUTargetApp.LoadFromRegIni(rif, SRegSection_MRUTargetApp);
    finally
      rif.Free;
    end;
     // Load languages
    LoadLanguages;
    cbTargetApp.Items.Assign(MRUTargetApp.Items);
    with FTranslations.Params do begin
      SetCBObject(cbSrcLang,  FSrcLangID);
      SetCBObject(cbTranLang, FTranLangID);
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
      if L and $ffff0000=0 then cbSrcLang.AddItem(Format('%.5d - 0x%0:.4x - %s', [L, Languages.Name[i]]), Pointer(L));
    end;
     // Copy the language list into cbTranLang
    cbTranLang.Items.Assign(cbSrcLang.Items);
  end;

end.
