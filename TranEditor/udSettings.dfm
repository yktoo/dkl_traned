object dSettings: TdSettings
  Left = 607
  Top = 413
  ActiveControl = eReposPath
  BorderStyle = bsDialog
  Caption = 'Translation Manager settings'
  ClientHeight = 171
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    419
    171)
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 8
    Top = 8
    Width = 404
    Height = 126
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      404
      126)
    object lReposPath: TLabel
      Left = 12
      Top = 12
      Width = 134
      Height = 13
      Caption = '&Translation repository path:'
      FocusControl = eReposPath
    end
    object lRemovePrefix: TLabel
      Left = 28
      Top = 76
      Width = 279
      Height = 13
      Caption = '(in this case you'#39'll have to assign shortcuts manually later)'
    end
    object eReposPath: TEdit
      Left = 12
      Top = 28
      Width = 303
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object bBrowseReposPath: TButton
      Left = 318
      Top = 28
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 1
      OnClick = bBrowseReposPathClick
    end
    object cbRemovePrefix: TCheckBox
      Left = 12
      Top = 56
      Width = 333
      Height = 17
      Caption = 
        '&Remove prefix character ('#39'&&'#39') when adding strings to repositor' +
        'y'
      TabOrder = 2
    end
    object cbAutoAddStrings: TCheckBox
      Left = 12
      Top = 96
      Width = 261
      Height = 17
      Caption = '&Automatically add new translations to repository'
      TabOrder = 3
    end
  end
  object bOK: TButton
    Left = 258
    Top = 141
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 338
    Top = 141
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
