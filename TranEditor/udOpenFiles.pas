unit udOpenFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdOpenFiles = class(TForm)
    pMain: TPanel;
    bOK: TButton;
    bCancel: TButton;
    lSource: TLabel;
    cbSource: TComboBox;
    bSourceBrowse: TButton;
    lTran: TLabel;
    cbTran: TComboBox;
    bTranBrowse: TButton;
    procedure bSourceBrowseClick(Sender: TObject);
    procedure bTranBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
  private
     // Имя language source-файла
    FSourceFile: String;
     // Имя файла для перевода
    FTranFile: String;
     // Если True - то это диалог создания трансляции, иначе - диалог открытия существующей
    FNewMode: Boolean;
     // Source and translation MRU list
    FSourceMRUStrings: TStrings;
    FTranMRUStrings: TStrings;
  protected
    procedure InitializeDialog;
    function  Execute: Boolean;
  end;

   // Отображает диалог создания/открытия трансляции. Если bNewMode=True, то вызвано создание, при этом недоступно поле
   //   файла трансляции, иначе вызвано открытие, доступны оба поля
  function SelectLangFiles(var sSourceFile, sTranFile: String; SourceMRUStrings, TranMRUStrings: TStrings; bNewMode: Boolean): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

  function SelectLangFiles(var sSourceFile, sTranFile: String; SourceMRUStrings, TranMRUStrings: TStrings; bNewMode: Boolean): Boolean;
  begin
    with TdOpenFiles.Create(Application) do
      try
        FSourceFile       := sSourceFile;
        FTranFile         := sTranFile;
        FSourceMRUStrings := SourceMRUStrings;
        FTranMRUStrings   := TranMRUStrings;
        FNewMode          := bNewMode;
        Result := Execute;
        if Result then begin
          sSourceFile := FSourceFile;
          sTranFile   := FTranFile;
        end;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdOpenFiles
   //===================================================================================================================

  procedure TdOpenFiles.AdjustOKCancel(Sender: TObject);
  begin
    bOK.Enabled := (cbSource.Text<>'') and (FNewMode or (cbTran.Text<>''));
  end;

  procedure TdOpenFiles.bOKClick(Sender: TObject);
  begin
     // Файл исходника
    FSourceFile := cbSource.Text;
    CheckFileExists(FSourceFile);
     // Если не создание нового - присваиваем файл трансляции
    if not FNewMode then begin
      FTranFile := cbTran.Text;
      CheckFileExists(FTranFile);
    end;
    ModalResult := mrOK;
  end;

  procedure TdOpenFiles.bSourceBrowseClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := SLangSourceFileExt;
        Filter     := SLangSourceFileFilter;
        FileName   := cbSource.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := SDlgTitle_SelectLangSourceFile;
        if Execute then begin
          cbSource.Text := FileName;
          AdjustOKCancel(nil);
        end;
      finally
        Free;
      end;
  end;

  procedure TdOpenFiles.bTranBrowseClick(Sender: TObject);
  begin
    with TSaveDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := STranFileFilter;
        FileName   := cbTran.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := SDlgTitle_SelectTranFile;
        if Execute then begin
          cbTran.Text := FileName;
          AdjustOKCancel(nil);
        end;
      finally
        Free;
      end;
  end;

  function TdOpenFiles.Execute: Boolean;
  begin
    InitializeDialog;
    Result := ShowModal=mrOK;
  end;

  procedure TdOpenFiles.InitializeDialog;
  begin
    cbSource.Items.Assign(FSourceMRUStrings);
    cbSource.Text := FSourceFile;
    if FNewMode then begin
      lTran.Hide;
      cbTran.Hide;
      bTranBrowse.Hide;
    end else begin
      cbTran.Items.Assign(FTranMRUStrings);
      cbTran.Text := FTranFile;
    end;
    AdjustOKCancel(nil);  
  end;

end.
