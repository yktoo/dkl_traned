program DKTranEd;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  ConsVars in 'ConsVars.pas',
  udSettings in 'udSettings.pas' {dSettings},
  udAbout in 'udAbout.pas' {dAbout},
  udOpenFiles in 'udOpenFiles.pas' {dOpenFiles},
  udDiffLog in 'udDiffLog.pas' {dDiffLog},
  udTranProps in 'udTranProps.pas' {dTranProps};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DKLang Translation Editor';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
