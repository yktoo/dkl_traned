object dSelLang: TdSelLang
  Left = 430
  Top = 284
  ActiveControl = cbLang
  BorderStyle = bsDialog
  Caption = 'Select a language'
  ClientHeight = 135
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    417
    135)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 8
    Top = 8
    Width = 402
    Height = 90
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      402
      90)
    object lLang: TLabel
      Left = 12
      Top = 12
      Width = 123
      Height = 13
      Caption = '&Select a language to add:'
      FocusControl = cbLang
    end
    object cbLang: TComboBox
      Left = 12
      Top = 28
      Width = 376
      Height = 21
      Style = csDropDownList
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
      OnChange = cbLangChange
    end
    object cbCopyCurLang: TCheckBox
      Left = 12
      Top = 60
      Width = 273
      Height = 17
      Caption = '&Copy all current language data to the new language'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object bOK: TButton
    Left = 256
    Top = 105
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 336
    Top = 105
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
