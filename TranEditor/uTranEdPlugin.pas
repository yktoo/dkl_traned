//**********************************************************************************************************************
//  $Id: uTranEdPlugin.pas,v 1.5 2006-09-03 18:35:28 dale Exp $
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
  IDKLang_TranEd_Plugin      = interface;
  IDKLang_TranEd_Application = interface;
  IDKLang_TranEd_Translator  = interface;

   //===================================================================================================================
   // Prototypes of procedures exported from a plugin DLL
   //===================================================================================================================

   // Returns number of distinct plugins implemented in a module. Must be named 'DKLTE_GetPluginCount'
  TDKLang_TranEd_GetPluginCountProc = procedure(out iCount: Integer); stdcall;
   // Instantiates and returns plugin with a specific index (ranged 0..PluginCount-1). Must be named 'DKLTE_GetPlugin'.
   //   TranEdApplication is Translation Editor application environment
  TDKLang_TranEd_GetPluginProc = procedure(iIndex: Integer; TranEdApplication: IDKLang_TranEd_Application; out Plugin: IDKLang_TranEd_Plugin); stdcall;

   //===================================================================================================================
   // Translation Editor application environment
   //===================================================================================================================

  IDKLang_TranEd_Application = interface(IInterface)
    ['{7270D20E-7320-484B-B7DB-DFA3AEEA1E6E}']
     // Closes all open files. Returns True if succeeded, False when the translation file is unsaved and the user has
     //   cancelled the action
    function  FilesClose: LongBool; stdcall;
     // Uses the specified file names as suggested, shows select files dialog and loads the files. Returns True if user
     //   clicked OK
    function  FilesOpen(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString): LongBool; stdcall;
     // Loads the specified files
    procedure FilesLoad(const wsLangSrcFileName, wsDisplayFileName, wsTranFileName: WideString); stdcall;
     // Saves the translation currently open into the specified file. bUnicode specifies whether it should be in ANSI
     //   encoding (bUnicode=False) or in Unicode (bUnicode=True). Returns True if saved OK, False when the user was
     //   warned about source and translation file encodings differ and cancelled the action
    function  FilesSave(const wsFileName: WideString; bUnicode: LongBool): LongBool; stdcall;
     // Translates selected entries using the supplied Translator interface
    procedure TranslateSelected(Translator: IDKLang_TranEd_Translator); stdcall;
     // Prop handlers
    function  GetAppHandle: HWND; stdcall;
    function  GetDisplayFileName: WideString; stdcall;
    function  GetIsFileOpen: LongBool; stdcall;
    function  GetIsModified: LongBool; stdcall;
    function  GetLangIDSource: LANGID; stdcall;
    function  GetLangIDTranslation: LANGID; stdcall;
    function  GetLanguageSourceFileName: WideString; stdcall;
    function  GetMainWindowHandle: HWND; stdcall;
    function  GetSelectedItemCount: Integer; stdcall;
    function  GetTranslationFileName: WideString; stdcall;
     // Props
     // -- Application window's handle
    property AppHandle: HWND read GetAppHandle;
     // -- Full path to translation file used to display original values. Empty string if there is no open language
     //    source file or no display file is used
    property DisplayFileName: WideString read GetTranslationFileName;
     // -- True when there is an open language source file
    property IsFileOpen: LongBool read GetIsFileOpen;
     // -- True if the translation file was modified and not yet saved
    property IsModified: LongBool read GetIsModified;
     // -- Source translation language ID
    property LangIDSource: LANGID read GetLangIDSource;
     // -- Target translation language ID
    property LangIDTranslation: LANGID read GetLangIDTranslation;
     // -- Full path to language source file. Empty string if there is no open language source file
    property LanguageSourceFileName: WideString read GetLanguageSourceFileName;
     // -- Main program window's handle
    property MainWindowHandle: HWND read GetMainWindowHandle;
     // -- Number of items currently selected
    property SelectedItemCount: Integer read GetSelectedItemCount;
     // -- Full path to translation file. Empty string if there is no open language source file or an unsaved
     //    translation is being edited
    property TranslationFileName: WideString read GetTranslationFileName;
  end;

   //===================================================================================================================
   // Single item translator interface
   //===================================================================================================================

  IDKLang_TranEd_Translator = interface(IInterface)
    ['{C05CA756-72B8-4218-94C7-63979DF07D59}']
     // Performs translation from source LANGID to target one. Should return True on successful translation, False if
     //   translation failed
    function  Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): LongBool; stdcall;
  end;

   //===================================================================================================================
   // An abstract Translation Editor plugin
   //===================================================================================================================

  IDKLang_TranEd_PluginAction = interface;

  IDKLang_TranEd_Plugin = interface(IInterface)
    ['{561450F5-AD45-4C60-A84D-36668DA248A0}']
     // Prop handlers
    function  GetActionCount: Integer; stdcall;
    function  GetActions(iIndex: Integer): IDKLang_TranEd_PluginAction; stdcall;
    function  GetName: WideString; stdcall;
     // Props
     // -- Plugin name. Example: 'SuperPlugin'
    property Name: WideString read GetName;
     // -- Number of different actions plugin implements
    property ActionCount: Integer read GetActionCount;
     // -- Plugin actions by index (iIndex is in range [0..ActionCount-1]; actions may be instantiated on read)
    property Actions[iIndex: Integer]: IDKLang_TranEd_PluginAction read GetActions;
  end;

   //===================================================================================================================
   // Plugin information, optional interface a plugin may implement
   //===================================================================================================================

  IDKLang_TranEd_PluginInfo = interface(IInterface)
    ['{561450F5-AD45-4C60-A84D-36668DA248A1}']
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
   // Plugin action (executed with a menu item, a button etc.)
   //===================================================================================================================

  IDKLang_TranEd_PluginAction = interface(IInterface)
    ['{32768B1A-9654-40EA-900B-AB94B8245A22}']
     // Should execute the action
    procedure Execute; stdcall;
     // Prop handlers
    function  GetHint: WideString; stdcall;
    function  GetIsEnabled: LongBool; stdcall;
    function  GetName: WideString; stdcall;
    function  GetStartsGroup: LongBool; stdcall;
     // Props
     // -- Action hint (displayed as a tooltip and in the status bar; use pipe ('|') character to separate tooltip and
     //    status bar text). Example: 'Translate using Universal Mind|Translates selected entries using Universal Mind'
    property Hint: WideString read GetHint;
     // -- True if action is enabled, False otherwise
    property IsEnabled: LongBool read GetIsEnabled;
     // -- Action name (menu item or button text). Example: '&Translate using Universal Mind'
    property Name: WideString read GetName;
     // -- If True, a separator is inserted before the item
    property StartsGroup: LongBool read GetStartsGroup;
  end;

implementation

end.


