@echo off
setlocal
SET /P ESTASEGURO=Quiere verificar la lectora de CD? (Y/n)?
IF /I "%ESTASEGURO%" NEQ "Y" GOTO END
for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  if [%%j]==[5] echo %%i
  )
endlocal
PAUSE