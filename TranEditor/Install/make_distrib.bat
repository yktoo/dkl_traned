@echo off
rem ********************************************************************************************************************
rem $Id: make_distrib.bat,v 1.1.1.1 2004-09-26 17:15:05 dale Exp $
rem --------------------------------------------------------------------------------------------------------------------
rem DKLang Localization Package
rem Copyright 2002-2004 DK Software, http://www.dk-soft.org/
rem ********************************************************************************************************************
rem ** Making bundle of the Translation Editor application

set VERSION=2.1
set OUT_FILE_NAME=dktraned-%VERSION%.zip

if exist %OUT_FILE_NAME% del %OUT_FILE_NAME%

rem -m3    = compression normal
rem -afzip = create zip archive
start /w C:\Progra~1\WinRAR\WinRAR.exe a -m3 -afzip %OUT_FILE_NAME% ..\DKTranEd.exe ..\Language\*.lng