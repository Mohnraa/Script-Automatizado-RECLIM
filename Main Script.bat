	@ECHO OFF
	title Script Activador de RECLIM 0.1 BETA

	:: Ejecutar como Administrador al abrir
	cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

	:: INICIADOR DE VARIABLES
	SET "alarm_warning=[console]::beep(1500,450);Start-Sleep -Milliseconds 150;[console]::beep(1500,450);Start-Sleep -Milliseconds 150;[console]::beep(1500,450)"

	:intro
	 For /L %%i in (10 -1 1)Do (
  	  For /F "Delims=" %%G in ('Choice /T 1 /N /C:0123456789h /D h')Do (
       Cls
   	   type "%~dp0logo.txt"
       ECHO 	== Iniciando preparacion normal en %%i segundos, presione 0 para empezar o [1-9] para mas opciones ==
       IF %%G EQU 0 GOTO antivirus
       IF %%G GTR 0 IF %%G LSS 10 GOTO main-menu
      )
     )
    GOTO antivirus

	:antivirus
	::Esta seccion abre Seguridad de Windows
	ECHO.
	ECHO -- Abriendo Seguridad de Windows --
	ECHO -- Mantenga la ventana abierta durante el proceso --
	ECHO -- Desactive Proteccion en tiempo real y proteccion en la nube para continuar --
	start /WAIT windowsdefender:
	PAUSE
	GOTO webtest

	:webtest
	:: Esta seccion verifica si existe una conexion a internet
	ECHO.
	ECHO -- Verificando conexion a internet --
	ping 8.8.8.8 > nul
	if "%errorlevel%" == "0" SET connected="0" && ECHO -- Conexion detectada, continuando -- && goto kmsonline
	ECHO !! Precaucion: Conexion a internet no detectada !! && call powershell "%alarm_warning%"
	CHOICE /C:SN /N /T 10 /D S /M ">> Desea volver a verificar la conexion? [S,N]: "
	if "%errorlevel%" == "1" GOTO webtest
	SET connected="1"
	goto kmsoffline

	:kmsoffline
	:: Esta seccion maneja el activador sin internet
	IF NOT EXIST "%~dp0aact\offline\AAct.exe" GOTO restoreactivators
	ECHO.
	ECHO -- Abriendo activador OFFLINE --
	ECHO -- Script continuara al cerrar el activador --
	start /WAIT "" "%~dp0aact\offline\AAct.exe"
	GOTO activation-check

	:kmsonline
	::Esta seccion abre los activadores
	IF NOT EXIST "%~dp0aact\online\AAct_Network.exe" GOTO restoreactivators
	ECHO.
	ECHO -- Abriendo activador ONLINE --
	ECHO -- Script continuara al cerrar el activador --
	start /WAIT "" "%~dp0aact\online\AAct_Network.exe"
	GOTO activation-check

	:activation-check
	call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "Notification" > nul
	if not errorlevel 1 (
  	 ECHO.
     ECHO !! WINDOWS NO SE ACTIVO CORRECTAMENTE !!
     ECHO == Se volvera a ejecutar el activador de Windows 10 ==
     PAUSE
     if %connected% == "0" (GOTO kmsonline) else (GOTO kmsoffline)
	) else (
   	   call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "Expire" > nul
       if not errorlevel 1 (
         ECHO.
         ECHO == WINDOWS SE ACTIVO CORRECTAMENTE - KMS ==
   	   ) else (
      	  call cscript //nologo %systemroot%\System32\slmgr.vbs /xpr | find /i "permanently" > nul
          if not errorlevel 1 (
            ECHO.
            ECHO == WINDOWS SE ACTIVO CORRECTAMENTE - LICENCIA DIGITAL ==
      	  )
   	   )
    )

	:: Seccion Licencia - Office 2019
	IF NOT EXIST "%PROGRAMFILES%\Microsoft Office\Office16\ospp.vbs" ECHO !! Precaucion: OFFICE NO ESTA INSTALADO !! && PAUSE && EXIT
	call cscript //nologo "%PROGRAMFILES%\Microsoft Office\Office16\ospp.vbs" /dstatus | find /i "LICENSED" > nul
	if not errorlevel 1 (
  	  ECHO == OFFICE SE ACTIVO CORRECTAMENTE ==
  	  PAUSE
  	  GOTO driverpack
	) else (
  	  ECHO.
  	  ECHO !! Precaucion: OFFICE 2019 NO SE ACTIVO CORRECTAMENTE !!
   	  ECHO == Se volvera a ejecutar el activador de Office ==
   	  if %connected% == "0" (GOTO kmsonline) else (GOTO kmsoffline)
	)

	:driverpack
	::Esta seccion abre DriverPack
	ECHO.
	ECHO -- Abriendo DriverPack --
	ECHO -- Script continuara al cerrar DriverPack --
	start /WAIT "" "%~dp0DriverPack.G\DriverPack"
	if %connected% == "0" GOTO mediatest
	GOTO mediatestoffline

	:mediatest
	ECHO.
	:: Esta seccion abre paginas de prueba de teclado, microfno y bocinas
	ECHO -- Abriendo paginas de prueba de bocinas, microfono y teclado --
	ECHO -- Script continuara al cerrar el navegador --
	start /WAIT chrome /incognito "https://www.onlinemictest.com/es/prueba-de-teclado/" " https://es.mictests.com" "https://www.youtube.com"
	GOTO cameratest

	:mediatestoffline
	ECHO.
	ECHO -- Abriendo prueba de audio y microfono OFFLINE --
	start control mmsys.cpl sounds
	ECHO -- Prueba ha sido abierta --
	PAUSE
	GOTO cameratest
	
	:cameratest
	ECHO.
	:: Esta seccion abre el programa de camara
	ECHO -- Abriendo aplicacion de camara --
	start /WAIT microsoft.windows.camera:
	ECHO -- Camara ha sido abierta --
	PAUSE
	GOTO cdtest

	:cdtest
	:: Esta seccion prueba el funcionamiento de lectora de CD (si existe)
	ECHO.
	ECHO -- Detectando lectoras de CD -
	SET found="N"
	for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  		if [%%j]==[5] SET found="Y" && CALL powershell "(new-object -COM Shell.Application).NameSpace(17).ParseName('%%i').InvokeVerb('Eject')"
  		)
	if %found% == "Y" (ECHO -- Lectoras detectadas y abiertas --) else (ECHO -- No se detectaron lectoras --)
	PAUSE
	GOTO summary

	:summary
	:: En esta seccion se hace el resumen de configuracion del equipo
	:: 1ra Seccion: Recopilar informacion
	:: CPU NAME
	for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value') do (
		SET "cpu_name=%%A"
	)
	:: RAM
	::SET "command=2^>nul systeminfo ^| findstr /b "Total Physical Memory:""
	::for /f "tokens=2 delims=:" %%A in ('%command%') do (
	::	set "ram=%%A"
	::)
	for /f "tokens=2 delims==" %%A in ('wmic memorychip get capacity /value') do (
		SET "ram-raw=%%A"
	)
	call :strlen ram-raw _lenghtram
	IF %_lenghtram% EQU 12 SET "ram=%ram-raw:~0,2%"
	IF %_lenghtram% EQU 11 SET "ram=%ram-raw:~0,1%"
	:: HDD
	for /f "tokens=2 delims==" %%A in ('wmic diskdrive get size /value') do (
		SET "hdd-raw=%%A"
		GOTO out-loop-hdd
	)
	:out-loop-hdd
	call :strlen hdd-raw _lenghthdd
	IF %_lenghthdd% EQU 14 SET "hdd_size=%hdd-raw:~0,4%"
	IF %_lenghthdd% EQU 13 SET "hdd_size=%hdd-raw:~0,3%"
	IF %_lenghthdd% EQU 12 SET "hdd_size=%hdd-raw:~0,2%"
	:: OS
	for /f "tokens=2 delims==" %%A in ('wmic os get Caption /value') do (
		SET "os=%%A"
	)
	::GPU+VRAM (VRAM QUEDA PENDIENTE)
	for /f "tokens=2 delims==" %%A in ('wmic path win32_VideoController get name /value') do (
		SET "gpu=%%A"
	)
	:: Marca y Modelo
	for /f "tokens=2 delims==" %%A in ('wmic computersystem get manufacturer /value') do (
		SET "marca=%%A"
	)
	for /f "tokens=2 delims==" %%A in ('wmic computersystem get model /value') do (
		SET "modelo=%%A"
	)
	:: 2da seccion: Mostrar informacion
	Cls
	ECHO.
	ECHO 	 		                   ---==== RESUMEN DEL SISTEMA ====---
	ECHO.
	ECHO ^>^> CPU:     %cpu_name%
	ECHO.
	ECHO ^>^> RAM:     %ram% GB
	ECHO.
	ECHO ^>^> HDD:     %hdd_size% GB
	ECHO.
	ECHO ^>^> OS:      %os%
	ECHO.
	ECHO ^>^> GPU:     %gpu%
	ECHO.
	ECHO ^>^> Modelo:  %marca% %modelo%
	ECHO.
	ECHO ======================================================================================================
	ECHO    ^>^> Antes de terminar, por favor revise los puertos USB y las salidas de video (VGA, HDMI, DP) ^<^<
	ECHO ======================================================================================================
	ECHO.
	CHOICE /C:Y /CS /N /M ">> Presione Y mayuscula para continuar..."
	ECHO. 
	ECHO. 
	ECHO. 
	ECHO. 
	ECHO. 
	ECHO 				   ^>^>^>^> El equipo se reiniciara en 5 segundos ^<^<^<^<
	ECHO.
	PAUSE
	EXIT


	:: == UTILIDADES == =============================================================================================

	:restoreactivators
	:: Script para restaurar activadores
	ECHO.
	ECHO -- Activadores desaparecidos, restaurando...
	tar -xf "%~dp0aact\Respaldo.zip" -C "%~dp0aact" > nul
	IF NOT EXIST "%~dp0aact\online\AAct_Network.exe" ECHO !! ERROR: RESTAURACION FALLIDA, REINTENTANDO !! && TIMEOUT 3 /nobreak > nul && GOTO restoreactivators
	IF NOT EXIST "%~dp0aact\offline\AAct.exe" ECHO !! ERROR: RESTAURACION FALLIDA, REINTENTANDO !! && TIMEOUT 3 /nobreak > nul && GOTO restoreactivators	
	ECHO -- Restauracion completa --
	TIMEOUT 3 /nobreak > nul
	if %connected% == "0" GOTO kmsonline
	GOTO kmsoffline

	:mediacheck
	:: Esta seccion verifica si existe una conexion a internet
	ECHO.
	ECHO -- Verificando conexion a internet --
	ping 1.1.1.1 > nul
	if "%errorlevel%" == "0" (SET connected="0" && ECHO -- Conexion detectada, continuando -- && goto mediatest)
	ECHO !! Precaucion: Conexion a internet no detectada !! && call powershell "%alarm_warning%"
	CHOICE /C:SN /N /T 10 /D S /M ">> Desea volver a verificar la conexion? [S,N]: "
	if "%errorlevel%" == "1" GOTO mediacheck
	SET connected="1"
	goto mediatestoffline

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

	:: == NO IMPLEMENTADO EN SCRIPT == ==============================================================================

	:testsound-offline
	ECHO.
	ECHO -- Reproduciendo sonido --
	call powershell [console]::beep(1500,1000)
	CHOICE /C:YRr /CS /M "Presione R para repetir el sonido o Y para continuar"
	if %ERRORLEVEL% EQU 1 GOTO reminders
	if %ERRORLEVEL% EQU 2 GOTO testsound-offline
	if %ERRORLEVEL% EQU 3 GOTO testsound-offline

	:devicemanager
	ECHO.
	::Esta seccion abre el administrador de dispositivos
	ECHO -- Abriendo administrador de dispositivos --
	ECHO -- Script continuara al cerrar la ventana --
	start /WAIT devmgmt.msc
	goto kmsonline
	
	:detect-type
	:: Script para determinar el tipo de equipo y las pruebas a hacer
	ECHO.
	ECHO -- Detectando tipo de equipo --
	set /a "chassNum=0" 
	set "command=2^>nul WMIC SystemEnclosure Get ChassisTypes /value" 
	for /f "tokens=2 delims=={}" %%A IN ('%command%') do ( 
	2>nul set /a "chassNum=%%A"

	:install-apps
	

	:: == MENUS == ==================================================================================================

	:main-menu
	Cls
	ECHO.
	ECHO						 ---=== MENU PRINCIPAL ===---
	ECHO.
	ECHO - [1]: Proceso de preparacion normal
	ECHO        (Activacion W10-Office + DriverPack + Pruebas Teclado/Camara/Sonido/CD)
	ECHO.
	ECHO - [2]: Proceso de preparacion rapida
	ECHO        (Activacion W10-Office, DriverPack)
	ECHO.
	ECHO - [3]: Preparacion desde cero
	ECHO        (Instalacion Programas/Office 2019 + Preparacion normal)
	ECHO.
	ECHO - [4]: Continuar preparacion desde cualquier paso
	ECHO.
	ECHO - [5]: Herramientas de Diagnostico / Reparacion
	ECHO.
	ECHO - [0]: SALIR
	ECHO.
	TIMEOUT 1 /nobreak > nul
	CHOICE /c:123450 /N /M " >> Opcion Seleccionada: "
	IF %ERRORLEVEL% EQU 6 EXIT
	IF %ERRORLEVEL% EQU 1 GOTO antivirus
	IF %ERRORLEVEL% EQU 2 GOTO antivirus
	IF %ERRORLEVEL% EQU 3 GOTO antivirus
	IF %ERRORLEVEL% EQU 4 GOTO steps-menu
	IF %ERRORLEVEL% EQU 5 ECHO -- NO IMPLEMENTADO -- && PAUSE && GOTO intro

	:steps-menu
	Cls
	ECHO.
	ECHO                           ---=== MENU DE PASOS ===---
	ECHO            (Se continuara el procedimiento desde el paso seleccionado)
	ECHO.
	ECHO - [1]: Desactivar antivirus
	ECHO.
	ECHO - [2]: Activacion Windows - Office
	ECHO.
	ECHO - [3]: Instalacion de Driver por DriverPack
	ECHO.
	ECHO - [4]: Prueba de Teclado / Sonido / Microfono
	ECHO.
	ECHO - [5]: Prueba de Camara Web
	ECHO.
	ECHO - [6]: Prueba de Lectora de CD
	ECHO.
	ECHO - [7]: Resumen del sistema
	ECHO.
	ECHO - [0]: REGRESAR A MENU PRINCIPAL
	ECHO.
	TIMEOUT 1 /nobreak > nul
	CHOICE /c:12345670 /N /M " >> Opcion Seleccionada: "
	IF %ERRORLEVEL% EQU 1 GOTO antivirus
	IF %ERRORLEVEL% EQU 2 GOTO webtest
	IF %ERRORLEVEL% EQU 3 GOTO driverpack
	IF %ERRORLEVEL% EQU 4 GOTO mediacheck
	IF %ERRORLEVEL% EQU 5 GOTO cameratest
	IF %ERRORLEVEL% EQU 6 GOTO cdtest
	IF %ERRORLEVEL% EQU 7 GOTO summary
	IF %ERRORLEVEL% EQU 8 GOTO main-menu

	:: UTILIDADES EOF


	:: COMENTARIOS ==================================================================================================

	:: == Iteracion actual ==
	:: VER MANERA DE VERIFICAR QUE OFFICE Y WINDOWS ESTEN ACTIVADOS AL FINAL // WIP
	:: MODIFICAR PRUEBA DE SONIDO OFFLINE
	:: AGREGAR INFORMACION DE TARJETA GRAFICA (NOMBRE, CANTIDAD DE ADAPTADORES, MEMORIA DEDICADA) // WIP
	:: IMPLEMENTAR SI EQUIPO ES ESCRITORIO O LAPTOP (wmic systemenclosure get chassistypes)
	:: AGREGAR CHECKLIST DE PASOS AL FINAL

	:: -NOTA: WINDOS 10 20H2 NO PERMITE INSTALAR DRIVERS POR DEVICE MANAGER

	:: == ESCRITORIO ==
	:: DESARROLLAR PRUEBAS MEDIA PARA ESCRITORIO (SALTAR MICROFONO)
	:: AGREGAR JUEGOS PARA PRUEBA GAMER

	:: < BUGS - ESTA ITERACION >

	:: == Proxima iteracion ==
	:: REVISAR COMPATIBILIDAD CON WINDOWS 7 (PROBABLEMENTE NUEVO SCRIPT)
	:: AGREGAR MALOS CAMINOS (MANEJO DE ERRORES DE ARCHIVO)
	:: COMPROBAR SI HAY CONTENIDO EN CD (COMPROBACION AUTOMATIZADA)
	:: REVISAR SI EL DISCO FUE EXPANDIDO (DISCO ESTE EN USO EN TOTALIDAD)
	:: HACER EL MENU DE OPCIONES CONTEXTUAL (LAPTOP/PC, ON/OFFLINE)
	:: AGREGAR PROGRAMAS DE DIAGNOSTICO Y TESTEO FINAL (CRYSTALDISK, FURMARK, AOMIPARTITION, AIDA64, DDU. )
	:: AGREGAR CASOS EN CASO QUE PROGRAMAS DE DIAGNOSTICO NO ESTAN ENCONTRADOS
	:: LLEVAR UN SEGUIMIENTO DE PASOS, AGREGAR RECUPERACION DE CIERRE INESPERADO, DAR OPCIONES DE RECUPERACIONES
	:: UN NOMBRE VRGS PARA EL SCRIPT
	:: AGREGAR MODO RAPIDO DE PREPARACION DE EQUIPOS
	:: VERIFICAR SI LOS ACTIVADORES HICIERON SU TRABAJO, SI NO REABRIRLOS
	:: AGREGAR VARIABLES BANDERA PARA CAMBIAR EL FLUJO DE PREPARACION SEGUN TIPO DE PREPARACION Y EQUIPO
	:: AGREGAR CAMINO PARA VIEJA Y NUEVA IMAGEN (REMOVER DEVICE MANAGER EN NUEVA IMAGEN)
	:: AGREGAR REDUNDACIA PARA PROCESOS
	:: VERIFICAR MANERA DE OBTENER EL TAMAÑO DE MULTIPLES HDD EN SUMMARY
	:: AGREGAR EN REMINDERS SOBRE LA BATERIA EN LAPTOPS

	:: EXPLORAR A DETALLE
	:: REPORTAR CANTIDAD DE MODULOS Y SU CAPACIDAD (wmic memorychip get capacity)


	:: >> IDEAS <<
	:: Script para clonacion de HDD
	:: Scipt post-formateo (Tipo WIPI) - WIP (OFFICE 2019/2016 - ACROBAT DC - VLC - CHROME - WINRAR x86/64)

	  