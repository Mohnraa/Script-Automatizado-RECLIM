@ECHO OFF
call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "Activated" > nul
if not errorlevel 1 (
   ECHO.
   ECHO == WINDOWS SE ACTIVO CORRECTAMENTE ==
   ECHO.
)

call cscript //nologo "%PROGRAMFILES%\Microsoft Office\Office16\ospp.vbs" /dstatus
PAUSE
EXIT