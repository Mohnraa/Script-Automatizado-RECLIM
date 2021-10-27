@echo off
call AcroRdrDC1700920044_es_ES_des.exe /sAll
TIMEOUT 5
call vlc-2.2.6-win32desatendido.exe /S
TIMEOUT 5
::CHROME NO SE INSTALA - REVISAR
call chrome_install.exe /silent /install
TIMEOUT 5
call WinRar_5.40_x64.exe /S