object dTranProps: TdTranProps
  Left = 573
  Top = 236
  ActiveControl = cbLang
  BorderStyle = bsDialog
  Caption = 'Translation properties'
  ClientHeight = 154
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    459
    154)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 8
    Top = 8
    Width = 444
    Height = 109
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      444
      109)
    object lLang: TLabel
      Left = 12
      Top = 12
      Width = 51
      Height = 13
      Caption = '&Language:'
      FocusControl = cbLang
    end
    object lAuthor: TLabel
      Left = 12
      Top = 52
      Width = 37
      Height = 13
      Caption = '&Author:'
      FocusControl = eAuthor
    end
    object cbLang: TComboBox
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
    object eAuthor: TEdit
      Left = 12
      Top = 68
      Width = 421
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
  object bOK: TButton
    Left = 298
    Top = 124
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 378
    Top = 124
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
