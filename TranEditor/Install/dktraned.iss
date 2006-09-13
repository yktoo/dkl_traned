;***********************************************************************************************************************
;   $Id: dktraned.iss,v 1.2 2006-09-13 14:38:07 dale Exp $
;-----------------------------------------------------------------------------------------------------------------------
;   DKLang Translation Editor
;   Copyright 2002-2006 DK Software, http://www.dk-soft.org/
;***********************************************************************************************************************
[Setup]
  AppName                = DKLang Translation Editor
  AppId                  = DKLang Translation Editor
  AppVerName             = {cm:NameAndVersion,DKLang Translation Editor,3.1}
  AppVersion             = 3.1
  AppCopyright           = Copyright ©2002-2006 DK Software
  AppPublisher           = DK Software
  AppPublisherURL        = http://www.dk-soft.org/
  AppSupportURL          = http://www.dk-soft.org/redir.php?action=support
  AppUpdatesURL          = http://www.dk-soft.org/redir.php?action=vercheck&product=dktraned&version=3.1
  AppMutex               = DK_TRAN_ED_MUTEX
  AllowNoIcons           = yes
  ChangesAssociations    = yes
  DisableStartupPrompt   = yes
  DefaultDirName         = {pf}\DK Software\DKLang Translation Editor
  DefaultGroupName       = DKLang Translation Editor
  OutputDir              = .
  OutputBaseFilename     = dktraned-3.1-setup
  VersionInfoVersion     = 3.1
  VersionInfoTextVersion = 3.1
  WizardImageFile        = SetupImage.bmp
  WizardSmallImageFile   = SetupImageSmall.bmp
  ; -- Compression
  SolidCompression       = yes
  Compression            = lzma

[Languages]
  Name: "en"; MessagesFile: compiler:Default.isl;           LicenseFile: eula-eng.rtf
  Name: "ru"; MessagesFile: compiler:Languages\Russian.isl; LicenseFile: eula-rus.rtf

[Tasks]
  Name: desktopicon;        Description: {cm:CreateDesktopIcon};             GroupDescription: {cm:AdditionalIcons};
  Name: desktopicon\common; Description: {cm:IconsAllUsers};                 GroupDescription: {cm:AdditionalIcons}; Flags: exclusive
  Name: desktopicon\user;   Description: {cm:IconsCurUser};                  GroupDescription: {cm:AdditionalIcons}; Flags: exclusive unchecked
  Name: quicklaunchicon;    Description: {cm:CreateQuickLaunchIcon};         GroupDescription: {cm:AdditionalIcons};
  Name: associate_dklang;   Description: {cm:AssocFileExtension,Translation Editor,.dklang};
  Name: associate_lng;      Description: {cm:AssocFileExtension,Translation Editor,.lng};

[Files]
  Source: "..\dktraned.exe";            DestDir: "{app}";
  Source: "..\Language\Russian.lng";    DestDir: "{app}\Language";
  Source: "..\dktraned.chm";            DestDir: "{app}";

[Icons]
  Name: "{group}\DKLang Translation Editor";                       Filename: "{app}\dktraned.exe";
  Name: "{commondesktop}\DKLang Translation Editor";               Filename: "{app}\dktraned.exe"; Tasks: desktopicon\common
  Name: "{userdesktop}\DKLang Translation Editor";                 Filename: "{app}\dktraned.exe"; Tasks: desktopicon\user
  Name: "{code:QuickLaunch|{pf}}\DKLang Translation Editor";       Filename: "{app}\dktraned.exe"; Tasks: quicklaunchicon
  Name: "{group}\{cm:UninstallProgram,DKLang Translation Editor}"; Filename: "{uninstallexe}";
  Name: "{group}\{cm:Help}";                                       Filename: "{app}\dktraned.chm"

[Registry]
  Root: HKCR; Subkey: ".dklang";                          ValueType: string; ValueData: "dklang.dklang";                 Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_dklang
  Root: HKCR; Subkey: "dklang.dklang";                    ValueType: string; ValueData: "DKLang language source file";   Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_dklang
  Root: HKCR; Subkey: "dklang.dklang\shell\open\command"; ValueType: string; ValueData: """{app}\dktraned.exe"" ""%1"""; Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_dklang
  Root: HKCR; Subkey: "dklang.dklang\DefaultIcon";        ValueType: string; ValueData: """{app}\dktraned.exe"",1";      Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_dklang
  Root: HKCR; Subkey: ".lng";                             ValueType: string; ValueData: "dklang.lng";                    Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_lng
  Root: HKCR; Subkey: "dklang.lng";                       ValueType: string; ValueData: "DKLang translation file";       Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_lng
  Root: HKCR; Subkey: "dklang.lng\shell\open\command";    ValueType: string; ValueData: """{app}\dktraned.exe"" ""%1"""; Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_lng
  Root: HKCR; Subkey: "dklang.lng\DefaultIcon";           ValueType: string; ValueData: """{app}\dktraned.exe"",1";      Flags: uninsdeletevalue uninsdeletekeyifempty; Tasks: associate_lng

[Run]
  Filename: "{app}\dktraned.exe"; Description: {cm:LaunchProgram,DKLang Translation Editor}; Flags: nowait postinstall skipifsilent

[CustomMessages]
; English
en.Help=DKLang Translation Editor Help
en.IconsAllUsers=For all users
en.IconsCurUser=For the current user only

; Russian
ru.Help=Справка по DKLang Translation Editor
ru.IconsAllUsers=Для всех пользователей
ru.IconsCurUser=Только для текущего пользователя

[Code]

   // Returns path to QuickLaunch directory
  function  QuickLaunch(Default: String): String;
  begin
    Result := ExpandConstant('{userappdata}')+'\Microsoft\Internet Explorer\Quick Launch';
  end;

