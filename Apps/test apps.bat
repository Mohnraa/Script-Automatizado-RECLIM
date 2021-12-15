@echo off
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
ECHO.
ECHO -- INICIANDO INSTALACION ACROBAT --
call AcroRdrDC1700920044_es_ES_des.exe
TIMEOUT 5
ECHO.
ECHO -- INICIANDO INSTALACION VLC --
call vlc-2.2.6-win32desatendido.exe /S
TIMEOUT 5
ECHO.
ECHO -- INICIANDO INSTALACION CHROME --
call chrome_install.exe
TIMEOUT 5
ECHO.
ECHO -- INICIANDO INSTALACION WINRAR --
call WinRar_5.40_x64.exe /S
ECHO.
ECHO == Instalacion completada! ==
TIMEOUT 5