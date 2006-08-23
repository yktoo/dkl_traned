//**********************************************************************************************************************
//  $Id: DKTranEd.dpr,v 1.11 2006-08-23 15:19:11 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
program DKTranEd;

uses
  Windows,
  Forms,
  ChmHlp in 'ChmHlp.pas',
  DKLTranEdFrm in 'DKLTranEdFrm.pas' {DKLTranEdForm: TTntForm},
  Main in 'Main.pas' {fMain},
  ConsVars in 'ConsVars.pas',
  udSettings in 'udSettings.pas' {dSettings},
  udAbout in 'udAbout.pas' {dAbout},
  udOpenFiles in 'udOpenFiles.pas' {dOpenFiles},
  udDiffLog in 'udDiffLog.pas' {dDiffLog},
  udTranProps in 'udTranProps.pas' {dTranProps},
  dkWebUtils in '..\..\dkWebUtils.pas',
  udFind in 'udFind.pas' {dFind},
  udPromptReplace in 'udPromptReplace.pas' {dPromptReplace},
  uTranEdPlugin in 'uTranEdPlugin.pas',
  uTranEdPluginUsage in 'uTranEdPluginUsage.pas';

{$R *.res}
{$R *.dkl_const.res}

var
  hMtx: THandle;

begin
   // Create mutex indicating that the program is running (used by installer)
  hMtx := CreateMutex(nil, False, 'DK_TRAN_ED_MUTEX');
   // Run the program
  Application.Initialize;
  Application.Title := 'DKLang Translation Editor';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
   // Kill the mutex
  if hMtx<>0 then CloseHandle(hMtx);
end.

