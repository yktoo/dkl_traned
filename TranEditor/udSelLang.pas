unit udSelLang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdSelLang = class(TForm)
    pMain: TPanel;
    bOK: TButton;
    bCancel: TButton;
    lLang: TLabel;
    cbLang: TComboBox;
    cbCopyCurLang: TCheckBox;
    procedure cbLangChange(Sender: TObject);
  private
//    FRootComp: TCompTranslationEntry;
//    FCurLang: LANGID;
//    procedure LoadLanguages;
  end;

//  function AddLanguage(RootComp: TCompTranslationEntry; wCurLang: LANGID): Boolean;
//  function ReplaceLanguage(RootComp: TCompTranslationEntry; wCurLang: LANGID): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

//  function AddLanguage(RootComp: TCompTranslationEntry; wCurLang: LANGID): Boolean;
//  begin
//    with TdSelLang.Create(Application) do
//      try
//        FRootComp := RootComp;
//        FCurLang  := wCurLang;
//        LoadLanguages;
//        Result := ShowModal=mrOK;
//        if Result then FRootComp.AddLanguage(Integer(cbLang.Items.Objects[cbLang.ItemIndex]), FCurLang, cbCopyCurLang.Checked and cbCopyCurLang.Enabled);
//      finally
//        Free;
//      end;
//  end;
//
//  function ReplaceLanguage(RootComp: TCompTranslationEntry; wCurLang: LANGID): Boolean;
//  begin
//    with TdSelLang.Create(Application) do
//      try
//        FRootComp := RootComp;
//        FCurLang  := wCurLang;
//        cbCopyCurLang.Hide;
//        lLang.Caption := SReplaceLangLabel;
//        LoadLanguages;
//        Result := ShowModal=mrOK;
//        if Result then FRootComp.ReplaceLanguage(FCurLang, Integer(cbLang.Items.Objects[cbLang.ItemIndex]));
//      finally
//        Free;
//      end;
//  end;

   //===================================================================================================================
   //  TdAddLang
   //===================================================================================================================

  procedure TdSelLang.cbLangChange(Sender: TObject);
  begin
//    bOK.Enabled := cbLang.ItemIndex>=0;
  end;

//  procedure TdSelLang.LoadLanguages;
//  var
//    LExisting: TLanguages;
//    i: Integer;
//    L: LCID;
//  begin
//    LExisting := TLanguages.Create;
//    try
//      FRootComp.BuildLangList(LExisting, True, True);
//      if LExisting.IndexOf(0)<0 then cbLang.AddItem('(default)', nil);
//      for i := 0 to Languages.Count-1 do begin
//        L := Languages.LocaleID[i];
//        if (L and $ffff0000=0) and (LExisting.IndexOf(L)<0) then cbLang.AddItem(Languages.Name[i], Pointer(L));
//      end;
//    finally
//      LExisting.Free;
//    end;
//    cbCopyCurLang.Enabled := FCurLang<>$ffff;
//  end;

end.
