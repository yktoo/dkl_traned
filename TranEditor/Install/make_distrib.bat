@echo off
rem ********************************************************************************************************************
rem $Id: make_distrib.bat,v 1.5 2004-11-27 12:38:08 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2004 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the Translation Editor application

set VERSION=2.4
set OUT_FILE_NAME=dktraned-%VERSION%.zip
set LANGSRC_FILE_NAME=dktraned-%VERSION%-LangSrc.zip

if exist %OUT_FILE_NAME% del %OUT_FILE_NAME%
if exist %LANGSRC_FILE_NAME% del %LANGSRC_FILE_NAME%

rem -m3    = compression normal
rem -afzip = create zip archive
start /w C:\Progra~1\WinRAR\WinRAR.exe a -m3 -afzip %OUT_FILE_NAME% ..\DKTranEd.exe ..\Language\*.lng ReadMe.txt
start /w C:\Progra~1\WinRAR\WinRAR.exe a -m3 -afzip %LANGSRC_FILE_NAME% ..\DKTranEd.dklang
