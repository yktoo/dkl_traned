//**********************************************************************************************************************
//  $Id: DemoPlugin.dpr,v 1.2 2006-08-24 13:34:04 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
library DemoPlugin;

uses
  Windows,
  uTranEdPlugin in '..\..\uTranEdPlugin.pas';

type
  TDemoPlugin = class(TInterfacedObject, IDKLang_TranEd_Plugin, IDKLang_TranEd_PluginInfo, IDKLang_TranEd_TranslationPlugin)
     // IDKLang_TranEd_Plugin
    function  GetName: WideString; stdcall;
     // IDKLang_TranEd_PluginInfo
    function  GetInfoAuthor: WideString; stdcall;
    function  GetInfoCopyright: WideString; stdcall;
    function  GetInfoDescription: WideString; stdcall;
    function  GetInfoVersion: Cardinal; stdcall;
    function  GetInfoVersionText: WideString; stdcall;
    function  GetInfoWebsiteURL: WideString; stdcall;
     // IDKLang_TranEd_TranslationPlugin
    function  Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): BOOL; stdcall;
    function  GetTranslateItemCaption: WideString; stdcall;
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

  function TDemoPlugin.GetTranslateItemCaption: WideString;
  begin
    Result := 'Demo translation';
  end;

  function TDemoPlugin.Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): BOOL;
  begin
    Result := True;
    wsResult := 'Hmmm, what it should look like: "'+wsSourceText+'"?';
  end;

   //===================================================================================================================
   // Exported procs
   //===================================================================================================================

  procedure DKLTE_GetPluginCount(out iCount: Integer); stdcall;
  begin
     // Only one plugin is implemented here
    iCount := 1;
  end;

  procedure DKLTE_GetPlugin(iIndex: Integer; out Plugin: IDKLang_TranEd_Plugin); stdcall;
  begin
    case iIndex of
       // The only valid plugin
      0:   Plugin := TDemoPlugin.Create;
      else Plugin := nil;
    end;
  end;

exports
  DKLTE_GetPluginCount,
  DKLTE_GetPlugin;

begin
end.
