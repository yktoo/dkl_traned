object dOpenFiles: TdOpenFiles
  Left = 565
  Top = 258
  ActiveControl = cbSourceFile
  BorderStyle = bsDialog
  Caption = 'Open language files'
  ClientHeight = 190
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
    190)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 8
    Top = 8
    Width = 577
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      577
      145)
    object lSource: TLabel
      Left = 12
      Top = 12
      Width = 103
      Height = 13
      Caption = '&Language source file:'
      FocusControl = cbSourceFile
    end
    object lTran: TLabel
      Left = 12
      Top = 96
      Width = 115
      Height = 13
      Caption = '&Translation (target) file:'
      FocusControl = cbTranFile
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
      Left = 12
      Top = 112
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
      TabOrder = 5
      OnChange = AdjustOKCancel
    end
    object bTranFileBrowse: TButton
      Left = 488
      Top = 112
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
  end
  object bOK: TButton
    Left = 431
    Top = 160
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
    Top = 160
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
