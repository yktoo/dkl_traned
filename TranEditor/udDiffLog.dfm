object dDiffLog: TdDiffLog
  Left = 348
  Top = 175
  ActiveControl = mMain
  BorderStyle = bsDialog
  Caption = 'Differences found'
  ClientHeight = 431
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    592
    431)
  PixelsPerInch = 96
  TextHeight = 13
  object bClose: TButton
    Left = 511
    Top = 401
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
  object mMain: TMemo
    Left = 8
    Top = 8
    Width = 575
    Height = 309
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnKeyPress = mMainKeyPress
  end
  object gbTotals: TGroupBox
    Left = 8
    Top = 320
    Width = 575
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Totals'
    TabOrder = 1
    object lbTotals: TListBox
      Left = 2
      Top = 15
      Width = 571
      Height = 56
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      ParentColor = True
      TabOrder = 0
      TabWidth = 70
    end
  end
  object cbAutoTranslate: TCheckBox
    Left = 8
    Top = 404
    Width = 501
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      '&Automatically translate all untranslated entries using Translat' +
      'ion Repository'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name'
      '*.SecondaryShortCuts')
    Left = 468
    Top = 376
    LangData = {
      080064446966664C6F67010100000001000000070043617074696F6E01050000
      00060062436C6F7365010100000002000000070043617074696F6E0005006D4D
      61696E000008006762546F74616C73010100000003000000070043617074696F
      6E0008006C62546F74616C7300000F0063624175746F5472616E736C61746501
      0100000004000000070043617074696F6E00}
  end
end
