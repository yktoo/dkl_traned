//**********************************************************************************************************************
//  $Id: DKTranEd.dpr,v 1.4 2004-09-11 17:58:01 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2004 DK Software, http://www.dk-soft.org/
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
  dkWebUtils in '..\..\dkWebUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DKLang Translation Editor';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
