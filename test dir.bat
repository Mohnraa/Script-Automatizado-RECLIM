::start /WAIT "" "%~dp0DriverPack.G\DriverPack"

@echo off
SET variable="0"
systeminfo | findstr /B /C:"OS Name" > %variable%
ECHO %variable%
pause