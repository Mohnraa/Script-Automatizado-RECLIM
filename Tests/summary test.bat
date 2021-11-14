@ECHO OFF

ECHO.
ECHO 	   ---==== RESUMEN DEL SISTEMA ====---
ECHO.
:: CPU NAME W/ MAX CLOCK
for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value') do (
	SET "cpu_name=%%A"
)
ECHO ^>^> CPU:     %cpu_name%
ECHO.

:: RAM SIZE
SET "command=2^>nul systeminfo ^| findstr /b "Total Physical Memory:""
for /f "tokens=2 delims=:" %%A in ('%command%') do (
	set "ram=%%A"
)
ECHO ^>^> RAM:%ram%
ECHO.

:: HDD
:: ESTE PARSING NO SIRVE PARA DISCOS DE 1TB PARA ARRIBA (REDISEÑAR)
for /f "tokens=2 delims==" %%A in ('wmic diskdrive get size /value') do (
	SET "hdd_size=%%A"
)
ECHO ^>^> HDD:     %hdd_size:~0,3% GB
ECHO.

:: OS
for /f "tokens=2 delims==" %%A in ('wmic os get Caption /value') do (
	SET "os=%%A"
)
ECHO ^>^> OS:      %os%
ECHO.

::GPU+VRAM (VRAM QUEDA PENDIENTE)
for /f "tokens=2 delims==" %%A in ('wmic path win32_VideoController get name /value') do (
	SET "gpu=%%A"
)
ECHO ^>^> GPU:     %gpu%
ECHO.

:: Marca y Modelo
for /f "tokens=2 delims==" %%A in ('wmic computersystem get manufacturer /value') do (
	SET "marca=%%A"
)
for /f "tokens=2 delims==" %%A in ('wmic computersystem get model /value') do (
	SET "modelo=%%A"
)

ECHO ^>^> Modelo:  %marca% %modelo%
ECHO.
CHOICE /C:Y /CS /N /M "-- Presione Y mayuscula para continuar..."
