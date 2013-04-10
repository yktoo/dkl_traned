inherited dOpenFiles: TdOpenFiles
  ActiveControl = cbSourceFile
  BorderStyle = bsDialog
  Caption = 'Open language files'
  ClientHeight = 226
  ClientWidth = 592
  DesignSize = (
    592
    226)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TTntPanel
    Left = 8
    Top = 8
    Width = 577
    Height = 181
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      577
      181)
    object lSource: TTntLabel
      Left = 12
      Top = 12
      Width = 103
      Height = 13
      Caption = '&Language source file:'
      FocusControl = cbSourceFile
    end
    object cbSourceFile: TTntComboBox
      Left = 12
      Top = 28
      Width = 473
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = AdjustOKCancel
    end
    object bSourceFileBrowse: TTntButton
      Left = 488
      Top = 28
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bSourceFileBrowseClick
    end
    object cbTranFile: TTntComboBox
      Left = 28
      Top = 144
      Width = 457
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 7
      OnChange = AdjustOKCancel
    end
    object bTranFileBrowse: TTntButton
      Left = 488
      Top = 144
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Bro&wse...'
      TabOrder = 8
      OnClick = bTranFileBrowseClick
    end
    object cbDisplayFile: TTntComboBox
      Left = 12
      Top = 72
      Width = 473
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 3
      OnChange = AdjustOKCancel
    end
    object bDisplayFileBrowse: TTntButton
      Left = 488
      Top = 72
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Brow&se...'
      TabOrder = 4
      OnClick = bDisplayFileBrowseClick
    end
    object cbUseDisplayFile: TTntCheckBox
      Left = 12
      Top = 52
      Width = 557
      Height = 17
      Caption = 
        '&Use the following translation file to display the values (inste' +
        'ad of ones of the source file):'
      TabOrder = 2
      OnClick = cbUseDisplayFileClick
    end
    object rbNewTran: TTntRadioButton
      Left = 12
      Top = 104
      Width = 557
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Create new translation'
      Checked = True
      TabOrder = 5
      TabStop = True
      OnClick = RBTranClick
    end
    object rbOpenTran: TTntRadioButton
      Left = 12
      Top = 124
      Width = 557
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Open an existing translation file:'
      TabOrder = 6
      OnClick = RBTranClick
    end
  end
  object bOK: TTntButton
    Left = 352
    Top = 196
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TTntButton
    Left = 432
    Top = 196
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TTntButton
    Left = 512
    Top = 196
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = ShowHelpNotify
  end
  object dklcMain: TDKLanguageController
    Left = 8
    Top = 188
    LangData = {
      0A00644F70656E46696C6573010100000001000000070043617074696F6E010E
      0000000500704D61696E000007006C536F757263650101000000020000000700
      43617074696F6E000C006362536F7572636546696C650000110062536F757263
      6546696C6542726F777365010100000003000000070043617074696F6E000A00
      63625472616E46696C6500000F00625472616E46696C6542726F777365010100
      000004000000070043617074696F6E000D006362446973706C617946696C6500
      00120062446973706C617946696C6542726F7773650101000000050000000700
      43617074696F6E0010006362557365446973706C617946696C65010100000006
      000000070043617074696F6E00090072624E65775472616E0101000000070000
      00070043617074696F6E000A0072624F70656E5472616E010100000008000000
      070043617074696F6E000300624F4B010100000009000000070043617074696F
      6E0007006243616E63656C01010000000A000000070043617074696F6E000500
      6248656C7001010000000B000000070043617074696F6E00}
  end
end
