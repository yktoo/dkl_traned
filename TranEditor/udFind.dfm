object dFind: TdFind
  Left = 331
  Top = 235
  ActiveControl = cbPattern
  BorderStyle = bsDialog
  Caption = 'Find or replace'
  ClientHeight = 293
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  DesignSize = (
    549
    293)
  PixelsPerInch = 96
  TextHeight = 13
  object lPattern: TLabel
    Left = 12
    Top = 16
    Width = 54
    Height = 13
    Caption = '&Search for:'
    FocusControl = cbPattern
  end
  object bOK: TButton
    Left = 264
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
  object bCancel: TButton
    Left = 464
    Top = 263
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    TabOrder = 9
    OnClick = bCancelClick
  end
  object cbPattern: TComboBox
    Left = 120
    Top = 12
    Width = 415
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 0
    OnChange = DlgDataChange
  end
  object cbReplacePattern: TComboBox
    Left = 120
    Top = 44
    Width = 415
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 2
    OnChange = DlgDataChange
  end
  object gbOptions: TGroupBox
    Left = 12
    Top = 76
    Width = 257
    Height = 109
    Caption = 'Options'
    TabOrder = 3
    DesignSize = (
      257
      109)
    object cbCaseSensitive: TCheckBox
      Left = 16
      Top = 20
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Case sensitive'
      TabOrder = 0
      OnClick = DlgDataChange
    end
    object cbWholeWords: TCheckBox
      Left = 16
      Top = 40
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Whole words only'
      TabOrder = 1
      OnClick = DlgDataChange
    end
    object cbSelOnly: TCheckBox
      Left = 16
      Top = 60
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search selecte&d only'
      TabOrder = 2
      OnClick = DlgDataChange
    end
    object cbPrompt: TCheckBox
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
  object rgOrigin: TRadioGroup
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
  object rgDirection: TRadioGroup
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
  object bAll: TButton
    Left = 364
    Top = 263
    Width = 95
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Replace &all'
    TabOrder = 8
    OnClick = bAllClick
  end
  object cbReplace: TCheckBox
    Left = 12
    Top = 44
    Width = 97
    Height = 17
    Caption = '&Replace with:'
    TabOrder = 1
    OnClick = cbReplaceClick
  end
  object gbScope: TGroupBox
    Left = 280
    Top = 76
    Width = 257
    Height = 109
    Caption = 'Scope'
    TabOrder = 4
    DesignSize = (
      257
      109)
    object cbSearchNames: TCheckBox
      Left = 12
      Top = 24
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search entry &names'
      TabOrder = 0
      OnClick = DlgDataChange
    end
    object cbSearchOriginal: TCheckBox
      Left = 12
      Top = 44
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Search &original values'
      TabOrder = 1
      OnClick = DlgDataChange
    end
    object cbSearchTranslated: TCheckBox
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
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name'
      '*.SecondaryShortCuts'
      'bOK.Caption')
    Left = 8
    Top = 260
    LangData = {
      05006446696E64010100000001000000070043617074696F6E01120000000300
      624F4B000007006243616E63656C010100000003000000070043617074696F6E
      0008006C5061747465726E010100000004000000070043617074696F6E000900
      63625061747465726E0000100063625265706C6163655061747465726E000009
      0067624F7074696F6E73010100000006000000070043617074696F6E000F0063
      624361736553656E736974697665010100000007000000070043617074696F6E
      000C00636257686F6C65576F726473010100000008000000070043617074696F
      6E000900636253656C4F6E6C7901010000000A000000070043617074696F6E00
      080072674F726967696E01020000000B000000070043617074696F6E0C000000
      05004974656D73000B007267446972656374696F6E01020000000D0000000700
      43617074696F6E0E00000005004974656D73000800636250726F6D7074010100
      00000F000000070043617074696F6E00040062416C6C01010000001000000007
      0043617074696F6E00090063625265706C616365010100000011000000070043
      617074696F6E000700676253636F706501010000001200000007004361707469
      6F6E000D0063625365617263684E616D65730101000000130000000700436170
      74696F6E00100063625365617263684F726967696E616C010100000014000000
      070043617074696F6E00120063625365617263685472616E736C617465640101
      00000015000000070043617074696F6E00}
  end
end
