object dOpenFiles: TdOpenFiles
  Left = 258
  Top = 255
  ActiveControl = cbSource
  BorderStyle = bsDialog
  Caption = 'Open language files'
  ClientHeight = 150
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
    150)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 8
    Top = 8
    Width = 577
    Height = 105
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      577
      105)
    object lSource: TLabel
      Left = 12
      Top = 12
      Width = 103
      Height = 13
      Caption = 'Language source file:'
      FocusControl = cbSource
    end
    object lTran: TLabel
      Left = 12
      Top = 52
      Width = 115
      Height = 13
      Caption = 'Translation (target) file:'
      FocusControl = cbTran
    end
    object cbSource: TComboBox
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
    object bSourceBrowse: TButton
      Left = 488
      Top = 28
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bSourceBrowseClick
    end
    object cbTran: TComboBox
      Left = 12
      Top = 68
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
      TabOrder = 2
      OnChange = AdjustOKCancel
    end
    object bTranBrowse: TButton
      Left = 488
      Top = 68
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Bro&wse...'
      TabOrder = 3
      OnClick = bTranBrowseClick
    end
  end
  object bOK: TButton
    Left = 431
    Top = 120
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
    Top = 120
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
