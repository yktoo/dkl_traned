object dSettings: TdSettings
  Left = 459
  Top = 268
  BorderStyle = bsDialog
  Caption = 'Program settings'
  ClientHeight = 190
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
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
        Width = 137
        Height = 13
        Caption = '&Translation Repository path:'
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
        Width = 329
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
        Width = 409
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 
          '&Remove prefix character ('#39'&&'#39') when adding strings to the Repos' +
          'itory'
        TabOrder = 2
        OnClick = AdjustOKCancel
      end
      object cbAutoAddStrings: TCheckBox
        Left = 8
        Top = 92
        Width = 409
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Automatically add new translations to the Repository'
        TabOrder = 3
        OnClick = AdjustOKCancel
      end
    end
    object tsInterface: TTabSheet
      Caption = 'Interface'
      ImageIndex = 1
      object lInterfaceFont: TLabel
        Left = 164
        Top = 12
        Width = 12
        Height = 13
        Caption = '...'
      end
      object lTableFont: TLabel
        Left = 164
        Top = 40
        Width = 12
        Height = 13
        Caption = '...'
      end
      object bInterfaceFont: TButton
        Left = 8
        Top = 8
        Width = 149
        Height = 23
        Caption = '&Interface font...'
        TabOrder = 0
        OnClick = bInterfaceFontClick
      end
      object bTableFont: TButton
        Left = 8
        Top = 36
        Width = 149
        Height = 23
        Caption = '&Table font...'
        TabOrder = 1
        OnClick = bTableFontClick
      end
    end
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name'
      '*.SecondaryShortCuts'
      'lInterfaceFont.Caption'
      'lTableFont.Caption')
    Left = 8
    Top = 152
    LangData = {
      09006453657474696E6773010100000001000000070043617074696F6E010F00
      00000300624F4B010100000002000000070043617074696F6E0007006243616E
      63656C010100000003000000070043617074696F6E00060070634D61696E0000
      0C0074735265706F7369746F7279010100000004000000070043617074696F6E
      000A006C5265706F7350617468010100000005000000070043617074696F6E00
      0D006C52656D6F7665507265666978010100000006000000070043617074696F
      6E000A00655265706F7350617468000010006242726F7773655265706F735061
      7468010100000007000000070043617074696F6E000E00636252656D6F766550
      7265666978010100000008000000070043617074696F6E00100063624175746F
      416464537472696E6773010100000009000000070043617074696F6E000B0074
      73496E7465726661636501010000000A000000070043617074696F6E000E006C
      496E74657266616365466F6E7400000A006C5461626C65466F6E7400000E0062
      496E74657266616365466F6E7401010000000D000000070043617074696F6E00
      0A00625461626C65466F6E7401010000000E000000070043617074696F6E00}
  end
end
