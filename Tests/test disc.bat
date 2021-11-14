@ECHO OFF >NUL
SETLOCAL EnableExtensions
echo(---
set "_memo_total="
    rem unfortunately, next command is (supposedly) locale dependent
for /F "tokens=1,* delims=:" %%G in ('
        systeminfo^|find /I "Physical Memory"
                                    ') do (
  set "_memo_inuse="
      rem remove spaces including no-break spaces
  for %%g in (%%H) do if /I NOT "%%g"=="MB" set "_memo_inuse=!_memo_inuse!%%g"
  if defined _memo_total ( set "_memo_avail=!_memo_inuse!" 
                  ) else ( set "_memo_total=!_memo_inuse!" )
  echo !_memo_inuse! [MB] %%G 
)
set /A "_memo_inuse=_memo_total - _memo_avail"
    rem in integer arithmetics: calculate percentage multipled by 100 
set /A "_perc_inuse=10000 * _memo_inuse / _memo_total"
set /A "_perc_avail=10000 * _memo_avail / _memo_total"
    rem debugging: mostly 9999 as `set /A` trucates quotients instead of rounding  
set /A "_perc__suma=_perc_inuse + _perc_avail
echo(---
call :formatpercent _perc_avail
call :formatpercent _perc_inuse
call :formatpercent _perc__suma
    rem display results
set _
ENDLOCAL
goto :eof

:formatpercent
    rem         simulates division by 100

    rem input : variable NAME (i.e. passed by reference)
    rem         it's value could vary from   0 to 10000   format mask ####0  
    rem output: variable VALUE 
    rem             respectively vary from .00 to 100.00  format mask ###.00
if NOT defined %1 goto :eof
SETLOCAL EnableDelayedExpansion
  set "aux5=     !%1!"
  set "aux5=%aux5:~-5%"
      rem repair unacceptable format mask ###.#0 to ###.00
  set "auxx=%aux5:~3,1%
  if "%auxx%"==" " set "aux5=%aux5:~0,3%0%aux5:~4%"
      REM       rem change format mask from ###.00 to common ##0.00
      REM   set "auxx=%aux5:~2,1%
      REM   if "%auxx%"==" " set "aux5=%aux5:~0,2%0%aux5:~3%" 
  set "aux6=%aux5:~0,3%.%aux5:~3%"
ENDLOCAL&set "%1=%aux6%"
goto :eof