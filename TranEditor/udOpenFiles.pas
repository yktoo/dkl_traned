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
    cbSourceFile: TComboBox;
    bSourceFileBrowse: TButton;
    lTran: TLabel;
    cbTranFile: TComboBox;
    bTranFileBrowse: TButton;
    cbDisplayFile: TComboBox;
    bDisplayFileBrowse: TButton;
    cbUseDisplayFile: TCheckBox;
    procedure bSourceFileBrowseClick(Sender: TObject);
    procedure bTranFileBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure AdjustOKCancel(Sender: TObject);
    procedure bDisplayFileBrowseClick(Sender: TObject);
    procedure cbUseDisplayFileClick(Sender: TObject);
  private
     // Source, display and translation file names
    FSourceFile: String;
    FDisplayFile: String;
    FTranFile: String;
     // True means that the dialog is for creating a new translation; otherwise this is for opening an existing one
    FNewMode: Boolean;
     // Source, display and translation MRU lists
    FSourceMRUStrings: TStrings;
    FDisplayMRUStrings: TStrings;
    FTranMRUStrings: TStrings;
     // Updates the display-file controls depending on state of cbUseDisplayFile
    procedure UpdateDisplayFileCtls;
  protected
    procedure InitializeDialog;
    function  Execute: Boolean;
  end;

   // Shows new/open translation dialog. If bNewMode=True, the dialog is for creating a new translation; otherwise this
   //   is for opening an existing one
  function SelectLangFiles(var sSourceFile, sDisplayFile, sTranFile: String; SourceMRUStrings, DisplayMRUStrings, TranMRUStrings: TStrings; bNewMode: Boolean): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

  function SelectLangFiles(var sSourceFile, sDisplayFile, sTranFile: String; SourceMRUStrings, DisplayMRUStrings, TranMRUStrings: TStrings; bNewMode: Boolean): Boolean;
  begin
    with TdOpenFiles.Create(Application) do
      try
        FSourceFile        := sSourceFile;
        FDisplayFile       := sDisplayFile;
        FTranFile          := sTranFile;
        FSourceMRUStrings  := SourceMRUStrings;
        FDisplayMRUStrings := DisplayMRUStrings;
        FTranMRUStrings    := TranMRUStrings;
        FNewMode           := bNewMode;
        Result := Execute;
        if Result then begin
          sSourceFile  := FSourceFile;
          sDisplayFile := FDisplayFile;
          sTranFile    := FTranFile;
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
    bOK.Enabled :=
      (cbSourceFile.Text<>'') and
      (not cbUseDisplayFile.Checked or (cbDisplayFile.Text<>'')) and
      (FNewMode or (cbTranFile.Text<>''));
  end;

  procedure TdOpenFiles.bDisplayFileBrowseClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := STranFileFilter;
        FileName   := cbDisplayFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := SDlgTitle_SelectDisplayFile;
        if Execute then begin
          cbDisplayFile.Text := FileName;
          AdjustOKCancel(nil);
        end;
      finally
        Free;
      end;
  end;

  procedure TdOpenFiles.bOKClick(Sender: TObject);
  begin
     // Source file
    FSourceFile := cbSourceFile.Text;
    CheckFileExists(FSourceFile);
     // Display file
    if cbUseDisplayFile.Checked then begin
      FDisplayFile := cbDisplayFile.Text;
      CheckFileExists(FDisplayFile);
    end else
      FDisplayFile := '';
     // If not 'New' mode, assign the translation file as well
    if not FNewMode then begin
      FTranFile := cbTranFile.Text;
      CheckFileExists(FTranFile);
    end;
    ModalResult := mrOK;
  end;

  procedure TdOpenFiles.bSourceFileBrowseClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := SLangSourceFileExt;
        Filter     := SLangSourceFileFilter;
        FileName   := cbSourceFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := SDlgTitle_SelectLangSourceFile;
        if Execute then begin
          cbSourceFile.Text := FileName;
          AdjustOKCancel(nil);
        end;
      finally
        Free;
      end;
  end;

  procedure TdOpenFiles.bTranFileBrowseClick(Sender: TObject);
  begin
    with TSaveDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := STranFileFilter;
        FileName   := cbTranFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := SDlgTitle_SelectTranFile;
        if Execute then begin
          cbTranFile.Text := FileName;
          AdjustOKCancel(nil);
        end;
      finally
        Free;
      end;
  end;

  procedure TdOpenFiles.cbUseDisplayFileClick(Sender: TObject);
  begin
    UpdateDisplayFileCtls;
    if Visible and cbUseDisplayFile.Checked then cbDisplayFile.SetFocus;
    AdjustOKCancel(nil);
  end;

  function TdOpenFiles.Execute: Boolean;
  begin
    InitializeDialog;
    Result := ShowModal=mrOK;
  end;

  procedure TdOpenFiles.InitializeDialog;
  begin
     // Source file
    cbSourceFile.Items.Assign(FSourceMRUStrings);
    cbSourceFile.Text := FSourceFile;
     // Display file
    cbDisplayFile.Items.Assign(FDisplayMRUStrings);
    cbDisplayFile.Text := FDisplayFile;
    cbUseDisplayFile.Checked := FDisplayFile<>'';
     // Translation file
    if FNewMode then begin
      lTran.Hide;
      cbTranFile.Hide;
      bTranFileBrowse.Hide;
    end else begin
      cbTranFile.Items.Assign(FTranMRUStrings);
      cbTranFile.Text := FTranFile;
    end;
    UpdateDisplayFileCtls;
    AdjustOKCancel(nil);  
  end;

  procedure TdOpenFiles.UpdateDisplayFileCtls;
  begin
    EnableWndCtl(cbDisplayFile, cbUseDisplayFile.Checked);
    bDisplayFileBrowse.Enabled := cbUseDisplayFile.Checked;
  end;

end.
