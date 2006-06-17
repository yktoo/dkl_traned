//**********************************************************************************************************************
//  $Id: DKTranEd.dpr,v 1.8 2006-06-17 04:19:28 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
program DKTranEd;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  ConsVars in 'ConsVars.pas',
  udSettings in 'udSettings.pas' {dSettings},
  udAbout in 'udAbout.pas' {dAbout},
  udOpenFiles in 'udOpenFiles.pas' {dOpenFiles},
  udDiffLog in 'udDiffLog.pas' {dDiffLog},
  udTranProps in 'udTranProps.pas' {dTranProps},
  dkWebUtils in '..\..\dkWebUtils.pas',
  udFind in 'udFind.pas' {dFind},
  udPromptReplace in 'udPromptReplace.pas' {dPromptReplace};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DKLang Translation Editor';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
