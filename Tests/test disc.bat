@ECHO OFF

for /f "tokens=2 delims==" %%A in ('wmic ComputerSystem get TotalPhysicalMemory /value') do (
     SET "ram-raw=%%A"
)
call :strlen ram-raw _lenghtram
IF %_lenghtram% EQU 12 SET "ram-dec=%ram-raw:~0,2%.%ram-raw:~2,1%"
IF %_lenghtram% EQU 11 SET "ram-dec=%ram-raw:~0,1%.%ram-raw:~1,1%"

for /f "tokens=1,2 delims=." %%a  in ("%ram-dec%") do (
  set first_part=%%a
  set second_part=%%b
)

set second_part=%second_part:~0,1%
if defined second_part if %second_part% GEQ 5 ( 

    set /a ram=%first_part%+1
) else ( 
    set /a ram=%first_part%
)

echo ^>^> %ram%
PAUSE
EXIT

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
GOTO :eof