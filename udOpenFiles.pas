//**********************************************************************************************************************
//  $Id: udOpenFiles.pas,v 1.9 2006-08-23 15:19:11 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udOpenFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TdOpenFiles = class(TDKLTranEdForm)
    bCancel: TTntButton;
    bDisplayFileBrowse: TTntButton;
    bHelp: TTntButton;
    bOK: TTntButton;
    bSourceFileBrowse: TTntButton;
    bTranFileBrowse: TTntButton;
    cbDisplayFile: TTntComboBox;
    cbSourceFile: TTntComboBox;
    cbTranFile: TTntComboBox;
    cbUseDisplayFile: TTntCheckBox;
    dklcMain: TDKLanguageController;
    lSource: TTntLabel;
    pMain: TTntPanel;
    rbNewTran: TTntRadioButton;
    rbOpenTran: TTntRadioButton;
    procedure AdjustOKCancel(Sender: TObject);
    procedure bDisplayFileBrowseClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bSourceFileBrowseClick(Sender: TObject);
    procedure bTranFileBrowseClick(Sender: TObject);
    procedure cbUseDisplayFileClick(Sender: TObject);
    procedure RBTranClick(Sender: TObject);
  private
     // Source, display and translation file names
    FSourceFile: WideString;
    FDisplayFile: WideString;
    FTranFile: WideString;
     // Source, display and translation MRU lists
    FSourceMRUStrings: TStrings;
    FDisplayMRUStrings: TStrings;
    FTranMRUStrings: TStrings;
     // Updates the display-file controls depending on state of cbUseDisplayFile
    procedure UpdateDisplayFileCtls;
     // Updates the translation-file controls depending on state of radiobuttons
    procedure UpdateTranFileCtls;
  protected
    procedure DoCreate; override;
    procedure ExecuteInitialize; override;
  end;

   // Shows new/open translation dialog. If bNewMode=True, the dialog is for creating a new translation; otherwise this
   //   is for opening an existing one
  function SelectLangFiles(var wsSourceFile, wsDisplayFile, wsTranFile: WideString; SourceMRUStrings, DisplayMRUStrings, TranMRUStrings: TStrings): Boolean;

implementation
{$R *.dfm}
uses ConsVars;

  function SelectLangFiles(var wsSourceFile, wsDisplayFile, wsTranFile: WideString; SourceMRUStrings, DisplayMRUStrings, TranMRUStrings: TStrings): Boolean;
  begin
    with TdOpenFiles.Create(Application) do
      try
        FSourceFile        := wsSourceFile;
        FDisplayFile       := wsDisplayFile;
        FTranFile          := wsTranFile;
        FSourceMRUStrings  := SourceMRUStrings;
        FDisplayMRUStrings := DisplayMRUStrings;
        FTranMRUStrings    := TranMRUStrings;
        Result := ExecuteModal;
        if Result then begin
          wsSourceFile  := FSourceFile;
          wsDisplayFile := FDisplayFile;
          wsTranFile    := FTranFile;
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
      (not rbOpenTran.Checked or (cbTranFile.Text<>''));
  end;

  procedure TdOpenFiles.bDisplayFileBrowseClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := STranFileExt;
        Filter     := DKLangConstW('STranFileFilter');
        FileName   := cbDisplayFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := DKLangConstW('SDlgTitle_SelectDisplayFile');
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
     // Translation file
    if rbOpenTran.Checked then begin
      FTranFile := cbTranFile.Text;
      CheckFileExists(FTranFile);
    end else
      FTranFile := '';
    ModalResult := mrOK;
  end;

  procedure TdOpenFiles.bSourceFileBrowseClick(Sender: TObject);
  begin
    with TOpenDialog.Create(Self) do
      try
        DefaultExt := SLangSourceFileExt;
        Filter     := DKLangConstW('SLangSourceFileFilter');
        FileName   := cbSourceFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := DKLangConstW('SDlgTitle_SelectLangSourceFile');
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
        Filter     := DKLangConstW('STranFileFilter');
        FileName   := cbTranFile.Text;
        Options    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
        Title      := DKLangConstW('SDlgTitle_SelectTranFile');
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

  procedure TdOpenFiles.DoCreate;
  begin
    inherited DoCreate;;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_open_files;
  end;

  procedure TdOpenFiles.ExecuteInitialize;
  begin
    inherited ExecuteInitialize;
     // Source file
    cbSourceFile.Items.Assign(FSourceMRUStrings);
    cbSourceFile.Text := FSourceFile;
     // Display file
    cbDisplayFile.Items.Assign(FDisplayMRUStrings);
    cbDisplayFile.Text := FDisplayFile;
    cbUseDisplayFile.Checked := FDisplayFile<>'';
    UpdateDisplayFileCtls;
     // Translation file
    cbTranFile.Items.Assign(FTranMRUStrings);
    cbTranFile.Text := FTranFile;
    rbOpenTran.Checked := FTranFile<>'';
    UpdateTranFileCtls;
    AdjustOKCancel(nil);
  end;

  procedure TdOpenFiles.RBTranClick(Sender: TObject);
  begin
    UpdateTranFileCtls;
    if Visible and rbOpenTran.Checked then cbTranFile.SetFocus;
    AdjustOKCancel(nil);
  end;

  procedure TdOpenFiles.UpdateDisplayFileCtls;
  begin
    EnableWndCtl(cbDisplayFile, cbUseDisplayFile.Checked);
    bDisplayFileBrowse.Enabled := cbUseDisplayFile.Checked;
  end;

  procedure TdOpenFiles.UpdateTranFileCtls;
  begin
    EnableWndCtl(cbTranFile, rbOpenTran.Checked);
    bTranFileBrowse.Enabled := rbOpenTran.Checked;
  end;

end.


