//**********************************************************************************************************************
//  $Id: uTranEdPluginUsage.pas,v 1.2 2006-08-24 13:34:04 dale Exp $
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
  PPluginInfoBlock = ^TPluginInfoBlock;
  TPluginInfoBlock = record
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
 