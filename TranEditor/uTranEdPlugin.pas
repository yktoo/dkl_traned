//**********************************************************************************************************************
//  $Id: uTranEdPlugin.pas,v 1.2 2006-08-24 13:34:04 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
// Translation Editor plugin interface declarations
//
unit uTranEdPlugin;

interface
uses Windows;

type
  IDKLang_TranEd_Plugin = interface;

   //===================================================================================================================
   // Prototypes of procedures exported from a plugin DLL
   //===================================================================================================================

   // Returns number of plugins implemented in a module. Must be named 'DKLTE_GetPluginCount'
  TDKLang_TranEd_GetPluginCountProc = procedure(out iCount: Integer); stdcall;
   // Instantiates and returns plugin with a specific index (ranged 0..PluginCount-1). Must be named 'DKLTE_GetPlugin'
  TDKLang_TranEd_GetPluginProc = procedure(iIndex: Integer; out Plugin: IDKLang_TranEd_Plugin); stdcall;

   //===================================================================================================================
   // An abstract Translation Editor plugin
   //===================================================================================================================

  IDKLang_TranEd_Plugin = interface(IInterface)
    ['{561450F5-AD45-4C60-A84D-36668DA248A0}']
     // Prop handlers
    function  GetName: WideString; stdcall;
     // Props
     // -- Plugin name. Example: 'SuperPlugin'
    property Name: WideString read GetName;
  end;

   //===================================================================================================================
   // Plugin information, optional interface
   //===================================================================================================================

  IDKLang_TranEd_PluginInfo = interface(IInterface)
    ['{7CE81CD7-56B2-410C-B873-C7AC24C5C289}']
     // Prop handlers
    function  GetInfoAuthor: WideString; stdcall;
    function  GetInfoCopyright: WideString; stdcall;
    function  GetInfoDescription: WideString; stdcall;
    function  GetInfoVersion: Cardinal; stdcall;
    function  GetInfoVersionText: WideString; stdcall;
    function  GetInfoWebsiteURL: WideString; stdcall;
     // Props
     // -- Module author info. Example: 'SuperSoft Solutions Inc.'
    property InfoAuthor: WideString read GetInfoAuthor;
     // -- Module copyright info. Example: 'Copyright (c)1890-2005 SuperSoft Solutions Inc.'
    property InfoCopyright: WideString read GetInfoCopyright;
     // -- Module description. Example: 'A plugin doing just everything'
    property InfoDescription: WideString read GetInfoDescription;
     // -- Module version; each byte represents a single version part. Example: version 1.1.10.78 will be $01010a4e
    property InfoVersion: Cardinal read GetInfoVersion;
     // -- Module text version; should match InfoVersion value, but additionally can include a version qualifier.
     //    Example: '1.1.10.78 beta'
    property InfoVersionText: WideString read GetInfoVersionText;
     // -- Module website or download URL. Example: 'http://www.dk-soft.org/';
    property InfoWebsiteURL: WideString read GetInfoWebsiteURL;
  end;

   //===================================================================================================================
   // Translation plugin
   //===================================================================================================================

  IDKLang_TranEd_TranslationPlugin = interface(IDKLang_TranEd_Plugin)
    ['{561450F5-AD45-4C60-A84D-36668DA248A1}']
     // Tries to make a translation from source LANGID to target one. Should return True on successful translation,
     //   False if translation failed; in the latter case sTranslatedText may contain error message text (e. g.
     //   'Translation unavailable' or 'HTTP request failed')
    function  Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): BOOL; stdcall;
     // Prop handlers
    function  GetTranslateItemCaption: WideString; stdcall;
     // Props
     // -- Translation menu item caption. Example: 'Translate with a dictionary'
    property TranslateItemCaption: WideString read GetTranslateItemCaption;
  end;
  
implementation

end.


