//**********************************************************************************************************************
//  $Id: uTranEdPluginUsage.pas,v 1.1 2006-08-23 15:18:21 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit uTranEdPluginUsage;

interface
uses Windows, ConsVars, uTranEdPlugin;

   //===================================================================================================================
   // Plugin info record
   //===================================================================================================================
type
  PPluginInfo = ^TPluginInfo;
  TPluginInfo = record
    hLib:   HMODULE;               // Handle to plugin DLL
    Plugin: IDKLang_TranEd_Plugin; // Plugin instance
  end;

const  
  SPluginsRelativePath           = 'Plugins\';
  
   // Exported proc names
  SPlugin_GetPluginCountProcName = 'DKLTE_GetPluginCount';
  SPlugin_GetPluginProcName      = 'DKLTE_GetPlugin';

implementation

end.
 