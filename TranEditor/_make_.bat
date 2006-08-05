@echo off
rem ********************************************************************************************************************
rem $Id: _make_.bat,v 1.1 2006-08-05 21:42:34 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2006 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the Translation Editor application

set VERSION=3.0

set BASE_DIR=C:\Delphi\CVS projects\dale\DKLang\TranEditor
set HELP_DIR=%BASE_DIR%\Help
set INSTALL_DIR=%BASE_DIR%\Install

set SETUP_SCRIPT_FILE_NAME=%INSTALL_DIR%\dktraned.iss
set LANGSRC_FILE_NAME=dktraned-%VERSION%-LangSrc.zip

set DELPHI=C:\Program Files\Borland\Delphi7
rem -B = Rebuild all
rem -W = Output warning messages
rem -H = Output hint messages
set DELPHI_OPTIONS=-B -W -H
set DELPHI_SWITCHES=A8B-C-D-G+H+I+J-L-M-O+P+Q-R-T-U-V+W-X+Y-Z1
set DELPHI_LIBRARY_PATH=%DELPHI%\tb2k\Source;%DELPHI%\tbx;%DELPHI%\Graphics32;%DELPHI%\RX\Units;%DELPHI%\vtv\Source;%DELPHI%\tnt;%DELPHI%\SynEdit\Source;c:\Delphi\CVSpro~1\dale\dklang
set DELPHI_COMPILER="%DELPHI%\Bin\dcc32.exe"

set HELP_COMPILER=C:\Program Files\HTML Help Workshop\hhc.exe  
set SETUP_COMPILER=C:\Program Files\Inno Setup 5\iscc.exe
set ARCHIVER=C:\Program Files\WinRAR\rar.exe
set CLEANER=C:\Delphi\CVS projects\dale\DKLang\cleanup.bat

if exist %LANGSRC_FILE_NAME% del %LANGSRC_FILE_NAME%

rem Make some cleanup
call "%CLEANER%"

rem --------------------------------------------------------------------------------------------------------------------
echo == Compile help
cd "%HELP_DIR%"
"%HELP_COMPILER%" dktraned.hhp
if not errorlevel == 1 goto err
move dktraned.chm ..
if errorlevel == 1 goto err

rem --------------------------------------------------------------------------------------------------------------------
echo == Compile application
cd "%BASE_DIR%"
%DELPHI_COMPILER% dktraned.dpr %DELPHI_OPTIONS% -$%DELPHI_SWITCHES% "-U%DELPHI_LIBRARY_PATH%"
if errorlevel == 1 goto :err

rem --------------------------------------------------------------------------------------------------------------------
echo == Create setup
"%SETUP_COMPILER%" "%SETUP_SCRIPT_FILE_NAME%"
if errorlevel == 1 goto err

rem --------------------------------------------------------------------------------------------------------------------
echo == Create language source archive
cd "%BASE_DIR%"
rem -m3    = compression normal
rem -afzip = create zip archive
"%ARCHIVER%" a -m3 -afzip Install\%LANGSRC_FILE_NAME% DKTranEd.dklang >nul
if errorlevel == 1 goto err

goto ok

:err
pause
:ok

rem Make some cleanup again
call "%CLEANER%"
