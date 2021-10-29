@echo off
title Test para Audio offline

ECHO.
ECHO -- Reproduciendo sonido --
:play
call powershell [console]::beep(1375,100)
call powershell [console]::beep(1475,100)
call powershell [console]::beep(1575,100)
CHOICE /C:YRr /CS /N /M "Presione R para repetir el sonido o Y para continuar"
if %ERRORLEVEL% EQU 1 ECHO SALIO TEST!!
if %ERRORLEVEL% EQU 2 GOTO play
if %ERRORLEVEL% EQU 3 GOTO play
PAUSE
