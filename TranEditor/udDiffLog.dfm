object dDiffLog: TdDiffLog
  Left = 440
  Top = 239
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
  Position = poScreenCenter
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
    TabOrder = 0
  end
  object mMain: TMemo
    Left = 8
    Top = 8
    Width = 575
    Height = 385
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end
