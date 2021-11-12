@echo off 
setlocal 
set /a "chassNum=0" 
set "command=2^>nul WMIC SystemEnclosure Get ChassisTypes /value" 
for /f "tokens=2 delims=={}" %%A IN ("cscript //nologo %systemroot%\System32\slmgr.vbs /xpr") do ( 
2>nul set /a "chassNum=%%A" 
) 

ECHO %ChassNum%
CALL :CASE_%ChassNum%

:CASE_6
ECHO SEIS
PAUSE
EXIT

::if %chassNum%==0 (set /a "chassNum=2") 
::set _=;Other;Unknown;Desktop;Low Profile Desktop; 
::set _=%_%;Pizza Box;Mini Tower;Tower;Portable;Laptop;Notebook; 
::set _=%_%;Hand Held;Docking Station;All in One;Sub Notebook; 
::set _=%_%;Space-Saving;Lunch Box;Main System Chassis;Expansion Chassis; 
::set _=%_%;SubChassis;Bus Expansion Chassis;Peripheral Chassis; 
::set _=%_%;Storage Chassis;Rack Mount Chassis;Sealed-Case PC; 
::for /f "tokens=%chassNum% delims=; eol=" %%A in ("%_%") do ( 
::echo Chassis type is : %ChassNum% : %%A 
::) 
::pause