object dOpenFiles: TdOpenFiles
  Left = 357
  Top = 263
  ActiveControl = cbSourceFile
  BorderStyle = bsDialog
  Caption = 'Open language files'
  ClientHeight = 226
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    592
    226)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
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
    object lSource: TLabel
      Left = 12
      Top = 12
      Width = 103
      Height = 13
      Caption = '&Language source file:'
      FocusControl = cbSourceFile
    end
    object cbSourceFile: TComboBox
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
      Sorted = True
      TabOrder = 0
      OnChange = AdjustOKCancel
    end
    object bSourceFileBrowse: TButton
      Left = 488
      Top = 28
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bSourceFileBrowseClick
    end
    object cbTranFile: TComboBox
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
      Sorted = True
      TabOrder = 5
      OnChange = AdjustOKCancel
    end
    object bTranFileBrowse: TButton
      Left = 488
      Top = 144
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Bro&wse...'
      TabOrder = 6
      OnClick = bTranFileBrowseClick
    end
    object cbDisplayFile: TComboBox
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
      Sorted = True
      TabOrder = 3
      OnChange = AdjustOKCancel
    end
    object bDisplayFileBrowse: TButton
      Left = 488
      Top = 72
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Brow&se...'
      TabOrder = 4
      OnClick = bDisplayFileBrowseClick
    end
    object cbUseDisplayFile: TCheckBox
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
    object rbNewTran: TRadioButton
      Left = 12
      Top = 104
      Width = 557
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Create new translation'
      Checked = True
      TabOrder = 7
      TabStop = True
      OnClick = RBTranClick
    end
    object rbOpenTran: TRadioButton
      Left = 12
      Top = 124
      Width = 557
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Open an existing translation file:'
      TabOrder = 8
      OnClick = RBTranClick
    end
  end
  object bOK: TButton
    Left = 431
    Top = 196
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 511
    Top = 196
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
