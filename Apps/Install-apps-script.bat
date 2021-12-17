@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
ECHO.
ECHO -- Instalando Adobe Acrobat DC --
IF EXIST "%PROGRAMFILES(X86)%\Adobe\" (ECHO -- Adobe Acrobat DC ya esta instalado --) else (call AcroRdrDC1700920044_es_ES_des.exe && ECHO == Listo! ==)
TIMEOUT 5 > nul
ECHO.
ECHO -- Instalando VLC --
IF EXIST "%PROGRAMFILES(X86)%\VideoLAN\" (ECHO -- VLC ya esta instalado --) else (call vlc-2.2.6-win32desatendido.exe /S && ECHO == Listo! ==)
TIMEOUT 5 > nul
ECHO.
ECHO -- Instalando Google Chrome --
IF EXIST "%PROGRAMFILES(X86)%\Google\" (ECHO -- Google Chrome ya esta instalado --) else (call chrome_install.exe && ECHO == Listo! ==)
TIMEOUT 5 > nul
ECHO.
ECHO -- Instalando WinRAR --
for /f "tokens=2 delims==" %%A in ('wmic OS get OSArchitecture /value') do (
	SET "osType=%%A"
)
ECHO %osType% | find /i "64 bits" > nul
IF EXIST "%PROGRAMFILES%\WinRAR\" (ECHO -- WinRAR ya esta instalado --) else (IF EXIST "%PROGRAMFILES(X86)%\WinRAR\" (ECHO -- WinRAR ya esta instalado --) else (IF !errorlevel! EQU 0 (call WinRar_5.40_x64.exe /S && ECHO == Listo! ==) else (call WinRar_5.40_x86.exe /S && ECHO == Listo! ==)))
ECHO.
ECHO == Instalacion de programas completada! ==
TIMEOUT 5 > nul
EXIT

