inherited dFind: TdFind
  ActiveControl = cbPattern
  BorderStyle = bsDialog
  Caption = 'Find or replace'
  ClientHeight = 293
  ClientWidth = 547
  DesignSize = (
    547
    293)
  PixelsPerInch = 96
  TextHeight = 13
  object lPattern: TTntLabel
    Left = 12
    Top = 16
    Width = 54
    Height = 13
    Caption = '&Search for:'
    FocusControl = cbPattern
  end
  object bOK: TTntButton
    Left = 186
    Top = 263
    Width = 95
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '<find/replace>'
    Default = True
    Enabled = False
    TabOrder = 7
    OnClick = bOKClick
  end
  object bClose: TTntButton
    Left = 386
    Top = 263
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 9
  end
  object cbPattern: TTntComboBox
    Left = 120
    Top = 12
    Width = 417
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 0
    OnChange = DlgDataChange
  end
  object cbReplacePattern: TTntComboBox
    Left = 120
    Top = 44
    Width = 417
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 2
    OnChange = DlgDataChange
  end
  object gbOptions: TTntGroupBox
    Left = 12
    Top = 76
    Width = 257
    Height = 109
    Caption = 'Options'
    TabOrder = 3
    DesignSize = (
      257
      109)
    object cbCaseSensitive: TTntCheckBox
      Left = 16
      Top = 20
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Case sensitive'
      TabOrder = 0
      OnClick = DlgDataChange
    end
    object cbWholeWords: TTntCheckBox
      Left = 16
      Top = 40
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Whole words only'
      TabOrder = 1
      OnClick = DlgDataChange
    end
    object cbSelOnly: TTntCheckBox
      Left = 16
      Top = 60
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search selecte&d only'
      TabOrder = 2
      OnClick = DlgDataChange
    end
    object cbPrompt: TTntCheckBox
      Left = 16
      Top = 80
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Prompt on replace'
      TabOrder = 3
      OnClick = DlgDataChange
    end
  end
  object rgOrigin: TTntRadioGroup
    Left = 12
    Top = 192
    Width = 257
    Height = 61
    Caption = 'Origin'
    ItemIndex = 0
    Items.Strings = (
      'Fro&m the focused entry'
      '&Entire scope')
    TabOrder = 5
    OnClick = DlgDataChange
  end
  object rgDirection: TTntRadioGroup
    Left = 280
    Top = 192
    Width = 257
    Height = 61
    Caption = 'Direction'
    ItemIndex = 0
    Items.Strings = (
      '&Forward'
      '&Backward')
    TabOrder = 6
    OnClick = DlgDataChange
  end
  object bAll: TTntButton
    Left = 286
    Top = 263
    Width = 95
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Replace &all'
    TabOrder = 8
    OnClick = bAllClick
  end
  object cbReplace: TTntCheckBox
    Left = 12
    Top = 44
    Width = 97
    Height = 17
    Caption = '&Replace with:'
    TabOrder = 1
    OnClick = cbReplaceClick
  end
  object gbScope: TTntGroupBox
    Left = 280
    Top = 76
    Width = 257
    Height = 109
    Caption = 'Scope'
    TabOrder = 4
    DesignSize = (
      257
      109)
    object cbSearchNames: TTntCheckBox
      Left = 12
      Top = 24
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search entry &names'
      TabOrder = 0
      OnClick = DlgDataChange
    end
    object cbSearchOriginal: TTntCheckBox
      Left = 12
      Top = 44
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search &original values'
      TabOrder = 1
      OnClick = DlgDataChange
    end
    object cbSearchTranslated: TTntCheckBox
      Left = 12
      Top = 64
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search &translated values'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = DlgDataChange
    end
  end
  object bHelp: TTntButton
    Left = 466
    Top = 263
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 10
    OnClick = ShowHelpNotify
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      'bOK.Caption')
    Left = 8
    Top = 260
    LangData = {
      05006446696E64010100000001000000070043617074696F6E01130000000300
      624F4B0000060062436C6F7365010100000003000000070043617074696F6E00
      08006C5061747465726E010100000004000000070043617074696F6E00090063
      625061747465726E0000100063625265706C6163655061747465726E00000900
      67624F7074696F6E73010100000006000000070043617074696F6E000F006362
      4361736553656E736974697665010100000007000000070043617074696F6E00
      0C00636257686F6C65576F726473010100000008000000070043617074696F6E
      000900636253656C4F6E6C7901010000000A000000070043617074696F6E0008
      0072674F726967696E01020000000B000000070043617074696F6E0C00000005
      004974656D73000B007267446972656374696F6E01020000000D000000070043
      617074696F6E0E00000005004974656D73000800636250726F6D707401010000
      000F000000070043617074696F6E00040062416C6C0101000000100000000700
      43617074696F6E00090063625265706C61636501010000001100000007004361
      7074696F6E000700676253636F7065010100000012000000070043617074696F
      6E000D0063625365617263684E616D6573010100000013000000070043617074
      696F6E00100063625365617263684F726967696E616C01010000001400000007
      0043617074696F6E00120063625365617263685472616E736C61746564010100
      000015000000070043617074696F6E0005006248656C70010100000016000000
      070043617074696F6E00}
  end
end
