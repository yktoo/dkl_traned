inherited dTranProps: TdTranProps
  ActiveControl = cbSrcLang
  BorderStyle = bsDialog
  Caption = 'Translation properties'
  ClientHeight = 377
  ClientWidth = 459
  DesignSize = (
    459
    377)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TTntPanel
    Left = 8
    Top = 8
    Width = 444
    Height = 332
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      444
      332)
    object lSrcLang: TTntLabel
      Left = 12
      Top = 12
      Width = 249
      Height = 13
      Caption = '&Source Language (used for Translation Repository):'
      FocusControl = cbSrcLang
    end
    object lTranLang: TTntLabel
      Left = 12
      Top = 52
      Width = 104
      Height = 13
      Caption = '&Translation language:'
      FocusControl = cbTranLang
    end
    object lAuthor: TTntLabel
      Left = 12
      Top = 132
      Width = 37
      Height = 13
      Caption = '&Author:'
      FocusControl = eAuthor
    end
    object lAdditionalParams: TTntLabel
      Left = 12
      Top = 172
      Width = 250
      Height = 13
      Caption = 'A&dditional parameters (in the format '#39'Name=Value'#39'):'
      FocusControl = mAdditionalParams
    end
    object lTargetApp: TTntLabel
      Left = 12
      Top = 92
      Width = 130
      Height = 13
      Caption = '&Target Application/Version:'
      FocusControl = cbTargetApp
    end
    object cbSrcLang: TTntComboBox
      Left = 12
      Top = 28
      Width = 421
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 0
      OnChange = AdjustOKCancel
    end
    object cbTranLang: TTntComboBox
      Left = 12
      Top = 68
      Width = 421
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 1
      OnChange = AdjustOKCancel
    end
    object eAuthor: TTntEdit
      Left = 12
      Top = 148
      Width = 421
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = AdjustOKCancel
    end
    object mAdditionalParams: TTntMemo
      Left = 12
      Top = 188
      Width = 421
      Height = 131
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 4
      WordWrap = False
      OnChange = AdjustOKCancel
    end
    object cbTargetApp: TTntComboBox
      Left = 12
      Top = 108
      Width = 421
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 2
      OnChange = AdjustOKCancel
    end
  end
  object bOK: TTntButton
    Left = 216
    Top = 348
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TTntButton
    Left = 296
    Top = 348
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TTntButton
    Left = 376
    Top = 348
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = ShowHelpNotify
  end
  object MRUTargetApp: TTBMRUList
    MaxItems = 30
    Prefix = 'MRU'
    Left = 24
    Top = 212
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      'MRU*.Prefix')
    Left = 84
    Top = 212
    LangData = {
      0A00645472616E50726F7073010100000001000000070043617074696F6E010F
      0000000500704D61696E000008006C5372634C616E6701010000000200000007
      0043617074696F6E0009006C5472616E4C616E67010100000003000000070043
      617074696F6E0007006C417574686F7201010000000400000007004361707469
      6F6E0011006C4164646974696F6E616C506172616D7301010000000500000007
      0043617074696F6E000A006C5461726765744170700101000000060000000700
      43617074696F6E00090063625372634C616E6700000A0063625472616E4C616E
      670000070065417574686F72000011006D4164646974696F6E616C506172616D
      7300000B00636254617267657441707000000300624F4B010100000007000000
      070043617074696F6E0007006243616E63656C01010000000800000007004361
      7074696F6E000C004D5255546172676574417070000005006248656C70010100
      000009000000070043617074696F6E00}
  end
end
