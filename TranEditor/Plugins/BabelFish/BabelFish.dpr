//**********************************************************************************************************************
//  $Id: BabelFish.dpr,v 1.1 2006-08-23 15:18:21 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright ©DK Software, HTTP://www.dk-soft.org/
//**********************************************************************************************************************
library BabelFish;

uses
  Windows, SysUtils, Classes, TntSysUtils, IdHTTP, IdMultipartFormData,
  uTranEdPlugin in '..\..\uTranEdPlugin.pas';

type
  TBabelFishPlugin = class(TInterfacedObject, IDKLang_TranEd_Plugin, IDKLang_TranEd_TranslationPlugin)
     // IDKLang_TranEd_Plugin
    function  GetInfoAuthor: WideString; stdcall;
    function  GetInfoCopyright: WideString; stdcall;
    function  GetInfoDescription: WideString; stdcall;
    function  GetInfoName: WideString; stdcall;
    function  GetInfoVersion: Cardinal; stdcall;
    function  GetInfoVersionText: WideString; stdcall;
    function  GetInfoWebsiteURL: WideString; stdcall;
     // IDKLang_TranEd_TranslationPlugin
    function  Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): BOOL; stdcall;
    function  GetTranslateItemCaption: WideString; stdcall;
     // Returns a two-letter string corresponding to language ID
    function LangStringFromID(wLangID: LANGID): WideString;
  end;

const
  SAllowedLanguagePairs =
    'zh_en zt_en en_zh en_zt en_nl en_fr en_de en_el en_it en_ja en_ko en_pt en_ru en_es nl_en nl_fr fr_en fr_de fr_el '+
    'fr_it fr_pt fr_nl fr_es de_en de_fr el_en el_fr it_en it_fr ja_en ko_en pt_en pt_fr ru_en es_en es_fr';

   //===================================================================================================================
   // TBabelFishPlugin
   //===================================================================================================================

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

  function TBabelFishPlugin.GetInfoName: WideString;
  begin
    Result := 'BabelFish translation plugin';
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
    Result := 'HTTP://www.dk-soft.org/';
  end;

  function TBabelFishPlugin.GetTranslateItemCaption: WideString;
  begin
    Result := 'Translate with BabelFish';
  end;

  function TBabelFishPlugin.LangStringFromID(wLangID: LANGID): WideString;
  begin
    case wLangID of
      1033, 2057, 3081, 4105, 5129, 6153, 7177, 8201, 9225, 10249, 11273, 12297, 13321:
                                              Result := 'en';  // English
      1043, 2067:                             Result := 'nl';  // Dutch
      1036, 2060, 3084, 4108, 5132, 6156:     Result := 'fr';  // French
      1031, 2055,3079,4103,5127:              Result := 'de';  // German
      1032:                                   Result := 'el';  // Greek
      1040, 2064:                             Result := 'it';  // Italian
      1041:                                   Result := 'jp';  // Japanese
      1042:                                   Result := 'ko';  // Korean
      1046, 2070:                             Result := 'pt';  // Portuguese
      1049:                                   Result := 'ru';  // Russian
      1034, 2058, 3082, 4106, 5130, 6154, 7178, 8202, 9226, 10250, 11274, 12298, 13322, 14346, 15370, 16394, 17418,
        18442, 19466, 20490:                  Result := 'es';  // Spanish
      // ????:                                Result := 'zh';  // Chinese-simplified
      // ????:                                Result := 'zt';  // Chinese-traditional
      else                                    Result := '';        
    end;
  end;

  function TBabelFishPlugin.Translate(wSourceLangID, wTargetLangID: LANGID; const wsSourceText: WideString; out wsResult: WideString): BOOL;
  var
    ws: WideString;
    sSourceAsUtf8: UTF8String;
    i,iStrSize: Integer;
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
    if Pos(sLangPair, SAllowedLanguagePairs)=0 then
      wsResult := 'Language pair is not available for translation by AltaVista BabelFish.'
     // If OK 
    else begin
      HTTP := TIdHTTP.Create(nil);
      DataStream := TIdMultiPartFormDataStream.Create;
      Stream := TMemoryStream.Create;
      try
        ws := Tnt_WideStringReplace(wsSourceText, '%', '%%', [rfReplaceAll]);
         // Convert source to UTF8
        iStrSize := Length(ws)*2;
        SetString(sSourceAsUtf8, nil,iStrSize);
        UnicodeToUtf8(PChar(sSourceAsUtf8), iStrSize, PWideChar(ws), Length(ws));
         // Setup post
        DataStream.AddFormField('doit',     'done');
        DataStream.AddFormField('intl',     '1');
        DataStream.AddFormField('tt',       'urltext');
        DataStream.AddFormField('trtext',   sSourceAsUtf8);
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
          iStrSize := Stream.Size;
          SetString(ws, nil, iStrSize+1);
          Utf8ToUnicode(PWideChar(ws),iStrSize,PChar(Stream.Memory),iStrSize);
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

  procedure DKLTE_GetPluginCount(out iCount: Integer); stdcall;
  begin
     // Only one plugin is implemented here
    iCount := 1;
  end;

  procedure DKLTE_GetPlugin(iIndex: Integer; out Plugin: IDKLang_TranEd_Plugin); stdcall;
  begin
    case iIndex of
       // The only valid plugin
      0:   Plugin := TBabelFishPlugin.Create;
      else Plugin := nil;
    end;
  end;

exports
  DKLTE_GetPluginCount,
  DKLTE_GetPlugin;

begin
end.
