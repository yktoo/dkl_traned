//**********************************************************************************************************************
//  $Id: DemoPlugin.dpr,v 1.5 2006-09-12 13:29:40 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
library DemoPlugin;

uses
  Windows,
  uTranEdPlugin in '..\..\uTranEdPlugin.pas';

type
  TDemoPlugin = class(TInterfacedObject, IDKLang_TranEd_Plugin, IDKLang_TranEd_PluginInfo, IDKLang_TranEd_PluginAction)
  private
     // Host application environment
    FTranEdApplication: IDKLang_TranEd_Application;
     // IDKLang_TranEd_Plugin
    function  GetActionCount: Integer; stdcall;
    function  GetActions(iIndex: Integer): IDKLang_TranEd_PluginAction; stdcall;
    function  GetName: WideString; stdcall;
     // IDKLang_TranEd_PluginInfo
    function  GetInfoAuthor: WideString; stdcall;
    function  GetInfoCopyright: WideString; stdcall;
    function  GetInfoDescription: WideString; stdcall;
    function  GetInfoVersion: Cardinal; stdcall;
    function  GetInfoVersionText: WideString; stdcall;
    function  GetInfoWebsiteURL: WideString; stdcall;
     // IDKLang_TranEd_PluginAction
    function  IDKLang_TranEd_PluginAction.GetHint        = Action_GetHint;
    function  IDKLang_TranEd_PluginAction.GetIsEnabled   = Action_GetIsEnabled;
    function  IDKLang_TranEd_PluginAction.GetName        = Action_GetName;
    function  IDKLang_TranEd_PluginAction.GetStartsGroup = Action_GetStartsGroup;
    procedure IDKLang_TranEd_PluginAction.Execute        = Action_Execute;
    function  Action_GetHint: WideString; stdcall;
    function  Action_GetIsEnabled: LongBool; stdcall;
    function  Action_GetName: WideString; stdcall;
    function  Action_GetStartsGroup: LongBool; stdcall;
    procedure Action_Execute; stdcall;
  public
    constructor Create(ATranEdApplication: IDKLang_TranEd_Application);
  end;

  procedure TDemoPlugin.Action_Execute;
  begin
    MessageBox(FTranEdApplication.AppHandle, 'Hello World!', 'Info', 0);
  end;

  function TDemoPlugin.Action_GetHint: WideString;
  begin
    Result := 'Don''t hesitate to click me!';
  end;

  function TDemoPlugin.Action_GetIsEnabled: LongBool;
  begin
    Result := True;
  end;

  function TDemoPlugin.Action_GetName: WideString;
  begin
    Result := 'Demo plugin item';
  end;

  function TDemoPlugin.Action_GetStartsGroup: LongBool;
  begin
    Result := False;
  end;

  constructor TDemoPlugin.Create(ATranEdApplication: IDKLang_TranEd_Application);
  begin
    inherited Create;
    FTranEdApplication := ATranEdApplication;
  end;

  function TDemoPlugin.GetActionCount: Integer;
  begin
    Result := 1;
  end;

  function TDemoPlugin.GetActions(iIndex: Integer): IDKLang_TranEd_PluginAction;
  begin
    Result := Self; // Our object implements the single action by itself
  end;

  function TDemoPlugin.GetInfoAuthor: WideString;
  begin
    Result := 'Dmitry Kann';
  end;

  function TDemoPlugin.GetInfoCopyright: WideString;
  begin
    Result := 'Copyright ©2006 DK Software';
  end;

  function TDemoPlugin.GetInfoDescription: WideString;
  begin
    Result := 'A simple demo plugin';
  end;

  function TDemoPlugin.GetInfoVersion: Cardinal;
  begin
    Result := $01010000;
  end;

  function TDemoPlugin.GetInfoVersionText: WideString;
  begin
    Result := '1.1';
  end;

  function TDemoPlugin.GetInfoWebsiteURL: WideString;
  begin
    Result := 'http://www.dk-soft.org/';
  end;

  function TDemoPlugin.GetName: WideString;
  begin
    Result := 'Demo translation plugin';
  end;

   //===================================================================================================================
   // Exported procs
   //===================================================================================================================

  procedure DKLTE_GetPluginSubsystemVersion(out iVersion: Integer); stdcall;
  begin
     // We always should return this value
    iVersion := IDKLang_TranEd_PluginSubsystemVersion;
  end;

  procedure DKLTE_GetPluginCount(out iCount: Integer); stdcall;
  begin
     // Only one plugin is implemented here
    iCount := 1;
  end;

  procedure DKLTE_GetPlugin(iIndex: Integer; TranEdApplication: IDKLang_TranEd_Application; out Plugin: IDKLang_TranEd_Plugin); stdcall;
  begin
    case iIndex of
       // The only valid plugin
      0:   Plugin := TDemoPlugin.Create(TranEdApplication);
      else Plugin := nil;
    end;
  end;

exports
  DKLTE_GetPluginSubsystemVersion,
  DKLTE_GetPluginCount,
  DKLTE_GetPlugin;

begin
end.
