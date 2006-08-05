inherited dSettings: TdSettings
  BorderStyle = bsDialog
  Caption = 'Program settings'
  ClientHeight = 276
  ClientWidth = 592
  DesignSize = (
    592
    276)
  PixelsPerInch = 96
  TextHeight = 13
  object gbInterface: TGroupBox
    Left = 12
    Top = 136
    Width = 569
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Interface'
    TabOrder = 1
    object lInterfaceFont: TTntLabel
      Left = 168
      Top = 24
      Width = 12
      Height = 13
      Caption = '...'
    end
    object lTableFont: TTntLabel
      Left = 168
      Top = 52
      Width = 12
      Height = 13
      Caption = '...'
    end
    object bInterfaceFont: TTntButton
      Left = 12
      Top = 20
      Width = 149
      Height = 23
      Caption = '&Interface font...'
      TabOrder = 0
      OnClick = bInterfaceFontClick
    end
    object bTableFont: TTntButton
      Left = 12
      Top = 48
      Width = 149
      Height = 23
      Caption = '&Table font...'
      TabOrder = 1
      OnClick = bTableFontClick
    end
  end
  object gbRepository: TGroupBox
    Left = 12
    Top = 8
    Width = 569
    Height = 125
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Repository'
    TabOrder = 0
    DesignSize = (
      569
      125)
    object lReposPath: TTntLabel
      Left = 12
      Top = 20
      Width = 137
      Height = 13
      Caption = 'Tra&nslation Repository path:'
      FocusControl = eReposPath
    end
    object lRemovePrefix: TTntLabel
      Left = 28
      Top = 84
      Width = 279
      Height = 13
      Caption = '(in this case you'#39'll have to assign shortcuts manually later)'
    end
    object bBrowseReposPath: TTntButton
      Left = 482
      Top = 36
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bBrowseReposPathClick
    end
    object eReposPath: TTntEdit
      Left = 12
      Top = 36
      Width = 466
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object cbRemovePrefix: TTntCheckBox
      Left = 12
      Top = 64
      Width = 546
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        '&Remove prefix character ('#39'&&'#39') when adding strings to the Repos' +
        'itory'
      TabOrder = 2
      OnClick = AdjustOKCancel
    end
    object cbAutoAddStrings: TTntCheckBox
      Left = 12
      Top = 100
      Width = 546
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Automatically add new translations to the Repository'
      TabOrder = 3
      OnClick = AdjustOKCancel
    end
  end
  object bOK: TTntButton
    Left = 348
    Top = 246
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 3
    OnClick = bOKClick
  end
  object bCancel: TTntButton
    Left = 428
    Top = 246
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object cbIgnoreEncodingMismatch: TTntCheckBox
    Left = 12
    Top = 224
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Don'#39't &warn if language source and translation being saved have ' +
      'different encodings'
    TabOrder = 2
    OnClick = AdjustOKCancel
  end
  object bHelp: TTntButton
    Left = 508
    Top = 246
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 5
    OnClick = ShowHelpNotify
  end
  object dklcMain: TDKLanguageController
    Left = 536
    Top = 176
    LangData = {
      09006453657474696E6773010100000001000000070043617074696F6E011000
      00000300624F4B010100000002000000070043617074696F6E0007006243616E
      63656C010100000003000000070043617074696F6E000A006C5265706F735061
      7468010100000005000000070043617074696F6E000D006C52656D6F76655072
      65666978010100000006000000070043617074696F6E000A00655265706F7350
      617468000010006242726F7773655265706F7350617468010100000007000000
      070043617074696F6E000E00636252656D6F7665507265666978010100000008
      000000070043617074696F6E00100063624175746F416464537472696E677301
      0100000009000000070043617074696F6E000E006C496E74657266616365466F
      6E7400000A006C5461626C65466F6E7400000E0062496E74657266616365466F
      6E7401010000000D000000070043617074696F6E000A00625461626C65466F6E
      7401010000000E000000070043617074696F6E001800636249676E6F7265456E
      636F64696E674D69736D6174636801010000000F000000070043617074696F6E
      000C0067625265706F7369746F7279010100000010000000070043617074696F
      6E000B006762496E74657266616365010100000011000000070043617074696F
      6E0005006248656C70010100000012000000070043617074696F6E00}
  end
end
