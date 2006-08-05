inherited dPromptReplace: TdPromptReplace
  ActiveControl = bYes
  BorderStyle = bsDialog
  Caption = 'Confirm replace'
  ClientHeight = 196
  ClientWidth = 442
  DesignSize = (
    442
    196)
  PixelsPerInch = 96
  TextHeight = 13
  object lMessage: TTntLabel
    Left = 12
    Top = 12
    Width = 422
    Height = 37
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '...'
    Layout = tlCenter
    WordWrap = True
  end
  object bYes: TTntButton
    Left = 28
    Top = 168
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = '&Yes'
    Default = True
    ModalResult = 6
    TabOrder = 1
  end
  object bCancel: TTntButton
    Left = 268
    Top = 168
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object bReplaceAll: TTntButton
    Left = 108
    Top = 168
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = 'Replace &all'
    ModalResult = 10
    TabOrder = 2
  end
  object bNo: TTntButton
    Left = 188
    Top = 168
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = '&No'
    ModalResult = 7
    TabOrder = 3
  end
  object mText: TTntMemo
    Left = 12
    Top = 52
    Width = 422
    Height = 108
    Anchors = [akLeft, akTop, akRight, akBottom]
    HideSelection = False
    ParentColor = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object bHelp: TTntButton
    Left = 348
    Top = 168
    Width = 75
    Height = 23
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 5
    OnClick = ShowHelpNotify
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.SecondaryShortCuts')
    Left = 20
    Top = 60
    LangData = {
      0E006450726F6D70745265706C61636501010000000100000007004361707469
      6F6E0107000000040062596573010100000009000000070043617074696F6E00
      07006243616E63656C01010000000A000000070043617074696F6E0008006C4D
      65737361676500000B00625265706C616365416C6C01010000000C0000000700
      43617074696F6E000300624E6F01010000000D000000070043617074696F6E00
      05006D54657874000005006248656C7001010000000E00000007004361707469
      6F6E00}
  end
end
