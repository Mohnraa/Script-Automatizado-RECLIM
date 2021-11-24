@echo off
title Test para Audio offline

ECHO.
ECHO -- Reproduciendo sonido --
:play
call powershell "[console]::beep(1375,100) ; [console]::beep(1475,100) ; [console]::beep(1575,100)"
CHOICE /C:YR /N /M "Presione R para repetir el sonido o Y para continuar"
if %ERRORLEVEL% EQU 1 ECHO SALIO TEST!!
if %ERRORLEVEL% EQU 2 GOTO play
PAUSE
