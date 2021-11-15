@ECHO OFF
for /f "tokens=2 delims==" %%A in ('wmic diskdrive get size /value') do (
	SET "hdd-raw=%%A"
	GOTO out-loop
)
:out-loop
call :strlen hdd-raw _lenght
IF %_lenght% EQU 14 ECHO LONGITUD = %_lenght% && SET "hdd_size=%hdd-raw:~0,4%"
IF %_lenght% EQU 13 ECHO LONGITUD = %_lenght% && SET "hdd_size=%hdd-raw:~0,3%"
IF %_lenght% EQU 12 ECHO LONGITUD = %_lenght% && SET "hdd_size=%hdd-raw:~0,2%"
ECHO HDD SIZE = %hdd_size% GB
PAUSE
EXIT


goto:eof
:strlen  StrVar  [RtnVar]
  setlocal EnableDelayedExpansion
  set "s=#!%~1!"
  set "len=0"
  for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!s:~%%N,1!" neq "" (
      set /a "len+=%%N"
      set "s=!s:~%%N!"
    )
  )
  endlocal&if "%~2" neq "" (set %~2=%len%) else echo %len%