@echo off
ECHO -- CODIGO ANTES --
ECHO.
SET existDisc="N"
for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  if [%%j]==[5] SET existDisc="Y" && CALL powershell "(new-object -COM Shell.Application).NameSpace(17).ParseName('%%i').InvokeVerb('Eject')"
  )
if %existDisc% == "Y" (ECHO -- Lectoras detectadas y abiertas --) else (ECHO -- No se detectaron lectoras --)
ECHO.
ECHO -- CODIGO DESPUES --
PAUSE