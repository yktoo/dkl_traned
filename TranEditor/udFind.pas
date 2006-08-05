//**********************************************************************************************************************
//  $Id: udFind.pas,v 1.6 2006-08-05 21:42:34 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ConsVars,
  DKLTranEdFrm, DKLang, TntExtCtrls, StdCtrls, TntStdCtrls;

type
  TdFind = class(TDKLTranEdForm)
    bAll: TTntButton;
    bClose: TTntButton;
    bHelp: TTntButton;
    bOK: TTntButton;
    cbCaseSensitive: TTntCheckBox;
    cbPattern: TTntComboBox;
    cbPrompt: TTntCheckBox;
    cbReplace: TTntCheckBox;
    cbReplacePattern: TTntComboBox;
    cbSearchNames: TTntCheckBox;
    cbSearchOriginal: TTntCheckBox;
    cbSearchTranslated: TTntCheckBox;
    cbSelOnly: TTntCheckBox;
    cbWholeWords: TTntCheckBox;
    dklcMain: TDKLanguageController;
    gbOptions: TTntGroupBox;
    gbScope: TTntGroupBox;
    lPattern: TTntLabel;
    rgDirection: TTntRadioGroup;
    rgOrigin: TTntRadioGroup;
    procedure bAllClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbReplaceClick(Sender: TObject);
    procedure DlgDataChange(Sender: TObject);
  private
     // Procedure invoked when user starts search/replace
    FFindCallback: TFindCallback;
     // MRU lists
    FSearchMRUStrings: TStrings;
    FReplaceMRUStrings: TStrings;
     // Called whenever dialog or its controls state changed
    procedure StateChanged;
     // Starts searching/replacement
    procedure DoFind(bAll: Boolean);
  protected
    procedure DoCreate; override;
    procedure ExecuteInitialize; override;
  end;

  function ShowFindDialog(AFindCallback: TFindCallback; ASearchMRUStrings, AReplaceMRUStrings: TStrings): Boolean;

implementation
{$R *.dfm}

  function ShowFindDialog(AFindCallback: TFindCallback; ASearchMRUStrings, AReplaceMRUStrings: TStrings): Boolean;
  begin
    with TdFind.Create(Application) do
      try
        FFindCallback      := AFindCallback;
        FSearchMRUStrings  := ASearchMRUStrings;
        FReplaceMRUStrings := AReplaceMRUStrings;
        Result := ExecuteModal;
      finally
        Free;
      end;
  end;

   //===================================================================================================================
   // TdFind
   //===================================================================================================================

  procedure TdFind.bAllClick(Sender: TObject);
  begin
    DoFind(True);
  end;

  procedure TdFind.bOKClick(Sender: TObject);
  begin
    DoFind(False);
  end;

  procedure TdFind.cbReplaceClick(Sender: TObject);
  begin
    if Visible then begin
      StateChanged;
      if cbReplacePattern.CanFocus then cbReplacePattern.SetFocus;
    end;
  end;

  procedure TdFind.DlgDataChange(Sender: TObject);
  begin
    if Visible then StateChanged;
  end;

  procedure TdFind.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_find;
  end;

  procedure TdFind.DoFind(bAll: Boolean);
  begin
     // Clear the search-from-the-next flag on invoke
    Exclude(SearchParams.Flags, sfFromNext);
     // Save search parameters
    SearchParams.wsSearchPattern  := cbPattern.Text;
    SearchParams.wsReplacePattern := cbReplacePattern.Text;
    SearchParams.Flags            := [];
    if cbReplace.Checked          then Include(SearchParams.Flags, sfReplace);
    if cbCaseSensitive.Checked    then Include(SearchParams.Flags, sfCaseSensitive);
    if cbWholeWords.Checked       then Include(SearchParams.Flags, sfWholeWordsOnly);
    if cbSelOnly.Checked          then Include(SearchParams.Flags, sfSelectedOnly);
    if cbPrompt.Checked           then Include(SearchParams.Flags, sfPromptOnReplace);
    if cbSearchNames.Checked      then Include(SearchParams.Flags, sfSearchNames);
    if cbSearchOriginal.Checked   then Include(SearchParams.Flags, sfSearchOriginal);
    if cbSearchTranslated.Checked then Include(SearchParams.Flags, sfSearchTranslated);
    if rgOrigin.ItemIndex=1       then Include(SearchParams.Flags, sfEntireScope);
    if rgDirection.ItemIndex=1    then Include(SearchParams.Flags, sfBackward);
    if bAll                       then Include(SearchParams.Flags, sfReplaceAll);
     // Invoke the search function
    Hide;
    try
      if FFindCallback(SearchParams) then ModalResult := mrOK;
    finally
      if ModalResult<>mrOK then Show;
    end;
  end;

  procedure TdFind.ExecuteInitialize;
  begin
    inherited ExecuteInitialize;
     // Initialize the controls
    cbPattern.Items.Assign(FSearchMRUStrings);
    cbReplacePattern.Items.Assign(FReplaceMRUStrings);
    cbPattern.Text             := SearchParams.wsSearchPattern;
    cbReplace.Checked          := sfReplace in SearchParams.Flags;
    cbReplacePattern.Text      := SearchParams.wsReplacePattern;
    cbCaseSensitive.Checked    := sfCaseSensitive in SearchParams.Flags;
    cbWholeWords.Checked       := sfWholeWordsOnly in SearchParams.Flags;
    cbSelOnly.Checked          := sfSelectedOnly in SearchParams.Flags;
    cbPrompt.Checked           := sfPromptOnReplace in SearchParams.Flags;
    cbSearchNames.Checked      := sfSearchNames in SearchParams.Flags;
    cbSearchOriginal.Checked   := sfSearchOriginal in SearchParams.Flags;
    cbSearchTranslated.Checked := sfSearchTranslated in SearchParams.Flags;
    rgOrigin.ItemIndex         := iif(sfEntireScope in SearchParams.Flags, 1, 0);
    rgDirection.ItemIndex      := iif(sfBackward in SearchParams.Flags, 1, 0);
    StateChanged;
  end;

  procedure TdFind.StateChanged;
  var bReplaceMode, bPattern, bScope: Boolean;
  begin
    bReplaceMode := cbReplace.Checked;
    bPattern     := cbPattern.Text<>'';
    bScope       := cbSearchTranslated.Checked or
                    (not bReplaceMode and (cbSearchNames.Checked or cbSearchOriginal.Checked));
    EnableWndCtl(cbReplacePattern, bReplaceMode);
    cbPrompt.Enabled         := bReplaceMode;
    cbSearchNames.Enabled    := not bReplaceMode;
    cbSearchOriginal.Enabled := not bReplaceMode;
    bOK.Enabled              := bPattern and bScope;
    bOK.Caption              := ConstVal(iif(bReplaceMode, 'SBtn_Replace', 'SBtn_Find'));
    bAll.Enabled             := bReplaceMode and bPattern and bScope;
  end;

end.
