::start /WAIT "" "%~dp0DriverPack.G\DriverPack"

@echo off
::SET variable="0"
::systeminfo | findstr /B /C:"OS Name" > %variable%
::ECHO %variable%
::pause

IF EXIST "%~dp0aact\offline\AAct.exe" GOTO success
GOTO fail

:success
ECHO -- PROGRAMA EXISTE --
PAUSE
EXIT

:fail
ECHO -- PUTO DEFENDER! ( Ò__Ó)/ --
PAUSE
EXIT
