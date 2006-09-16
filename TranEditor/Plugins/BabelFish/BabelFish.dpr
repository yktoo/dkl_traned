//**********************************************************************************************************************
//  $Id: BabelFish.dpr,v 1.3 2006-09-16 11:58:34 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
library BabelFish;

uses
  Windows, SysUtils, Classes, TntSysUtils, IdHTTP, IdMultipartFormData,
  uTranEdPlugin in '..\..\uTranEdPlugin.pas';

type
  TBabelFishPlugin = class(
      TInterfacedObject,
      IDKLang_TranEd_Plugin, IDKLang_TranEd_PluginInfo, IDKLang_TranEd_PluginAction, IDKLang_TranEd_Translator)
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
     // IDKLang_TranEd_Translator
    function  Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): LongBool; stdcall;
     // Returns a two-letter string corresponding to language ID
    function LangStringFromID(wLangID: LANGID): WideString;
  public
    constructor Create(ATranEdApplication: IDKLang_TranEd_Application);
  end;

const
  asISO_639_1_LangCodes: Array[1..121] of String = (
    'ar',  'bg',  'ca',  'zh', 'cs',  'da',  'de',  'el',  'en', 'es',
    'fi',  'fr',  'he',  'hu', 'is',  'it',  'ja',  'ko',  'nl', 'no',
    'pl',  'pt',  'rm',  'ro', 'ru',  'sh',  'sk',  'sq',  'sv', 'th',
    'tr',  'ur',  'id',  'uk', 'be',  'sl',  'et',  'lv',  'lt', 'tg',
    'fa',  'vi',  'hy',  'az', 'eu',  'wen', 'mk',  'st',  'ts', 'tn',
    'ven', 'xh',  'zu',  'af', 'ka',  'fo',  'hi',  'mt',  'se', 'gv',
    'yi',  'ms',  'kk',  'ky', 'sw',  'tk',  'uz',  'tt',  'bn', 'pa',
    'gu',  'or',  'ta',  'te', 'kn',  'ml',  'as',  'mr',  'sa', 'mn',
    'bo',  'cy',  'km',  'lo', 'my',  'gl',  'kok', 'mni', 'sd', 'syr',
    'si',  'chr', 'iu',  'am', 'ber', 'ks',  'ne',  'fy',  'ps', 'tl',
    'div', '',    '',    'ha', '',    'yo',  '',    '',    '',   '',
    '',    'ibo', 'kau', 'om', 'ti',  'gn',  'haw', 'la',  'so', '',
    'pap');

   // Language pairs available for translation by BabelFish
  SAllowedLanguagePairs =
    'zh_en zt_en en_zh en_zt en_nl en_fr en_de en_el en_it en_ja en_ko en_pt en_ru en_es nl_en nl_fr fr_en fr_de fr_el '+
    'fr_it fr_pt fr_nl fr_es de_en de_fr el_en el_fr it_en it_fr ja_en ko_en pt_en pt_fr ru_en es_en es_fr';

   //===================================================================================================================
   // TBabelFishPlugin
   //===================================================================================================================

  procedure TBabelFishPlugin.Action_Execute;
  begin
    FTranEdApplication.TranslateSelected(Self);
  end;

  function TBabelFishPlugin.Action_GetHint: WideString;
  begin
    Result := 'Translate selected entries using AltaVista BabelFish service (Internet connection required)';
  end;

  function TBabelFishPlugin.Action_GetIsEnabled: LongBool;
  begin
    Result := FTranEdApplication.SelectedItemCount>0;
  end;

  function TBabelFishPlugin.Action_GetName: WideString;
  begin
    Result := 'Translate with BabelFish';
  end;

  function TBabelFishPlugin.Action_GetStartsGroup: LongBool;
  begin
    Result := False;
  end;

  constructor TBabelFishPlugin.Create(ATranEdApplication: IDKLang_TranEd_Application);
  begin
    inherited Create;
    FTranEdApplication := ATranEdApplication;
  end;

  function TBabelFishPlugin.GetActionCount: Integer;
  begin
    Result := 1;
  end;

  function TBabelFishPlugin.GetActions(iIndex: Integer): IDKLang_TranEd_PluginAction;
  begin
    Result := Self; // Our object implements the single action by itself  
  end;

  function TBabelFishPlugin.GetInfoAuthor: WideString;
  begin
    Result := 'Bruce J. Miller, Dmitry Kann';
  end;

  function TBabelFishPlugin.GetInfoCopyright: WideString;
  begin
    Result := '<none>';
  end;

  function TBabelFishPlugin.GetInfoDescription: WideString;
  begin
    Result := 'Plugin allowing for translation with AltaVista BabelFish service (requires Internet connection)';
  end;

  function TBabelFishPlugin.GetInfoVersion: Cardinal;
  begin
    Result := $00010000;
  end;

  function TBabelFishPlugin.GetInfoVersionText: WideString;
  begin
    Result := '0.1';
  end;

  function TBabelFishPlugin.GetInfoWebsiteURL: WideString;
  begin
    Result := 'http://www.dk-soft.org/';
  end;

  function TBabelFishPlugin.GetName: WideString;
  begin
    Result := 'BabelFish translation plugin';
  end;

  function TBabelFishPlugin.LangStringFromID(wLangID: LANGID): WideString;
  var wIsoLangID: LANGID;
  begin
     // Windows LANGID uses 10 bits for primary language and 6 bits for sublanguage
    wIsoLangID := wLangID AND $03ff;
    if (wIsoLangID>=Low(asISO_639_1_LangCodes)) and (wIsoLangID<=High(asISO_639_1_LangCodes)) then
      Result := asISO_639_1_LangCodes[wIsoLangID]
    else
      Result := '';
  end;

  function TBabelFishPlugin.Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): LongBool;
  var
    ws: WideString;
    i: Integer;
    DataStream: TIdMultiPartFormDataStream;
    Stream: TMemoryStream;
    HTTP: TIdHTTP;
    sLangPair: String;
    bSucceeded: Boolean;
  begin
    Result   := False;
    wsResult := '';
     // Build a language pair code to post
    sLangPair := LangStringFromID(wSourceLangID)+'_'+LangStringFromID(wTargetLangID);
     // Test the pair for availability
    if Pos(sLangPair, SAllowedLanguagePairs)>0 then begin
      HTTP := TIdHTTP.Create(nil);
      DataStream := TIdMultiPartFormDataStream.Create;
      Stream := TMemoryStream.Create;
      try
         // Setup post
        DataStream.AddFormField('doit',     'done');
        DataStream.AddFormField('intl',     '1');
        DataStream.AddFormField('tt',       'urltext');
        DataStream.AddFormField('trtext',   UTF8Encode(Tnt_WideStringReplace(wsSourceText, '%', '%%', [rfReplaceAll])));
        DataStream.AddFormField('lp',       sLangPair);
        DataStream.AddFormField('btnTrTxt', 'Translate');
         // Prepare request
        HTTP.Request.AcceptCharSet := 'UTF-8';
        HTTP.Request.ContentType   :=  'multipart/form-data';
        HTTP.Request.ContentLength := DataStream.Size;
        bSucceeded := False;
        try
          HTTP.Post('http://www.world.altavista.com/tr', DataStream, Stream);
          bSucceeded := True;
        except
          on e: Exception do wsResult := 'Connection failed: '+e.Message;
        end;
        if bSucceeded then begin
           // Get the result
          ws := TntAdjustLineBreaks(UTF8Decode(PChar(Stream.Memory))); 
           // Extract the translation
          i := Pos('<td bgcolor=white class=s><div style=padding:10px;>', ws);
          if i>0 then Delete(ws, 1, i+50);
          i := Pos('</div></td>', ws);
          if i>0 then Delete(ws, i, Length(ws));
           // Clean off the surrounding spaces, if any
          wsResult := Trim(ws);
          Result := wsResult<>wsSourceText;
        end;
      finally
        HTTP.Free;
        DataStream.Free;
        Stream.Free;
      end;
    end;
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
      0:   Plugin := TBabelFishPlugin.Create(TranEdApplication);
      else Plugin := nil;
    end;
  end;

exports
  DKLTE_GetPluginSubsystemVersion,
  DKLTE_GetPluginCount,
  DKLTE_GetPlugin;

begin
end.
