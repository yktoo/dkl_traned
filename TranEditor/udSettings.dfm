object dSettings: TdSettings
  Left = 459
  Top = 268
  BorderStyle = bsDialog
  Caption = 'Translation Manager settings'
  ClientHeight = 190
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    447
    190)
  PixelsPerInch = 96
  TextHeight = 13
  object bOK: TButton
    Left = 286
    Top = 160
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 366
    Top = 160
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object pcMain: TPageControl
    Left = 8
    Top = 8
    Width = 432
    Height = 147
    ActivePage = tsRepository
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsRepository: TTabSheet
      Caption = 'Repository'
      DesignSize = (
        424
        119)
      object lReposPath: TLabel
        Left = 8
        Top = 8
        Width = 134
        Height = 13
        Caption = '&Translation repository path:'
        FocusControl = eReposPath
      end
      object lRemovePrefix: TLabel
        Left = 24
        Top = 72
        Width = 279
        Height = 13
        Caption = '(in this case you'#39'll have to assign shortcuts manually later)'
      end
      object eReposPath: TEdit
        Left = 8
        Top = 24
        Width = 324
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object bBrowseReposPath: TButton
        Left = 341
        Top = 24
        Width = 75
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '&Browse...'
        TabOrder = 1
        OnClick = bBrowseReposPathClick
      end
      object cbRemovePrefix: TCheckBox
        Left = 8
        Top = 52
        Width = 333
        Height = 17
        Caption = 
          '&Remove prefix character ('#39'&&'#39') when adding strings to repositor' +
          'y'
        TabOrder = 2
        OnClick = AdjustOKCancel
      end
      object cbAutoAddStrings: TCheckBox
        Left = 8
        Top = 92
        Width = 261
        Height = 17
        Caption = '&Automatically add new translations to repository'
        TabOrder = 3
        OnClick = AdjustOKCancel
      end
    end
    object tsInterface: TTabSheet
      Caption = 'Interface'
      ImageIndex = 1
      object lInterfaceFont: TLabel
        Left = 132
        Top = 12
        Width = 12
        Height = 13
        Caption = '...'
      end
      object lTableFont: TLabel
        Left = 132
        Top = 40
        Width = 12
        Height = 13
        Caption = '...'
      end
      object bInterfaceFont: TButton
        Left = 8
        Top = 8
        Width = 117
        Height = 23
        Caption = '&Interface font...'
        TabOrder = 0
        OnClick = bInterfaceFontClick
      end
      object bTableFont: TButton
        Left = 8
        Top = 36
        Width = 117
        Height = 23
        Caption = '&Table font...'
        TabOrder = 1
        OnClick = bTableFontClick
      end
    end
  end
end
