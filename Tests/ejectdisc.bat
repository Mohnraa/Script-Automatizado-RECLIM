@ECHO OFF
:: Seccion Licencia W10
call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "Notification" > nul
if not errorlevel 1 (
   ECHO.
   ECHO !! WINDOWS NO SE ACTIVO CORRECTAMENTE !!
   ECHO == Se volvera a ejecutar el activador de Windows 10 ==
   PAUSE
) else (
   call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "Expire" > nul
   if not errorlevel 1 (
    ECHO.
    ECHO == WINDOWS SE ACTIVO CORRECTAMENTE - KMS ==
    PAUSE
   ) else (
      call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "permanently" > nul
      if not errorlevel 1 (
        ECHO.
        ECHO == WINDOWS SE ACTIVO CORRECTAMENTE - LICENCIA DIGITAL ==
        PAUSE
      )
   )
)

:: Seccion Licencia - Office 2019
IF NOT EXIST "%PROGRAMFILES%\Microsoft Office\Office16\ospp.vbs" GOTO office-not-installed
call cscript //nologo "%PROGRAMFILES%\Microsoft Office\Office16\ospp.vbs" /dstatus | find /i "LICENSED" > nul
if not errorlevel 1 (
  ECHO.
  ECHO == OFFICE SE ACTIVO CORRECTAMENTE ==
)
PAUSE
EXIT

:office-not-installed
ECHO.
ECHO !! OFFICE 2019 NO ESTA INSTALADO !!
ECHO == Se recomienda instalarlo antes de hacer este paso ==
PAUSE
EXIT


:: == ESTADOS DE LICENCIA W10
::Notification (Sin Licencia)
::Exipire (Licencia adquirida por KMS)
::Activated (Licencia Digital integrada a MB - Se deberia de saltar por defecto)
