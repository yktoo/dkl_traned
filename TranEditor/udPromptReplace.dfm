object dPromptReplace: TdPromptReplace
  Left = 479
  Top = 225
  ActiveControl = bYes
  BorderStyle = bsDialog
  Caption = 'Confirm replace'
  ClientHeight = 197
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    421
    197)
  PixelsPerInch = 96
  TextHeight = 13
  object lMessage: TLabel
    Left = 12
    Top = 12
    Width = 401
    Height = 37
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '<text>'
    Layout = tlCenter
    WordWrap = True
  end
  object bYes: TButton
    Left = 59
    Top = 167
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = '&Yes'
    Default = True
    ModalResult = 6
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 287
    Top = 167
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object bReplaceAll: TButton
    Left = 135
    Top = 167
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = 'Replace &all'
    ModalResult = 10
    TabOrder = 2
  end
  object bNo: TButton
    Left = 211
    Top = 167
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = '&No'
    ModalResult = 7
    TabOrder = 3
  end
  object mText: TMemo
    Left = 12
    Top = 52
    Width = 401
    Height = 109
    Anchors = [akLeft, akTop, akRight, akBottom]
    HideSelection = False
    ParentColor = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name'
      '*.SecondaryShortCuts'
      'lMessage.Caption')
    Left = 4
    Top = 164
    LangData = {
      0E006450726F6D70745265706C61636501010000000100000007004361707469
      6F6E0106000000040062596573010100000009000000070043617074696F6E00
      07006243616E63656C01010000000A000000070043617074696F6E0008006C4D
      65737361676500000B00625265706C616365416C6C01010000000C0000000700
      43617074696F6E000300624E6F01010000000D000000070043617074696F6E00
      05006D546578740000}
  end
end
