
	@ECHO OFF
	title Script Activador de RECLIM 1.0b

	:intro
	ECHO.
	type logo.txt
	ECHO.
	ECHO -- Iniciando, presione cualquier tecla para mas opciones --
	TIMEOUT 6 > nul
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
	if "%errorlevel%" == "0" SET connected="0" && goto netok
	ECHO !! Precaucion: Conexion a internet no detectada !!
	TIMEOUT /T 3 /NOBREAK > nul
	SET connected="1"
	goto kmsoffline

	:netok
	ECHO -- Conexion detectada, continuando... ---
	GOTO devicemanager

	:devicemanager
	ECHO.
	::Esta seccion abre el administrador de dispositivos
	ECHO -- Abriendo administrador de dispositivos --
	ECHO -- Script continuara al cerrar la ventana --
	start /WAIT devmgmt.msc
	goto kmsonline

	:kmsoffline
	:: Esta seccion maneja el activador sin internet
	ECHO.
	IF NOT EXIST "%~dp0aact\offline\AAct.exe" GOTO restoreactivators
	ECHO -- Abriendo activador OFFLINE --
	ECHO -- Script continuara al cerrar el activador --
	start /WAIT "" "%~dp0aact\offline\AAct.exe"
	GOTO driverpack

	:kmsonline
	::Esta seccion abre los activadores
	ECHO.
	IF NOT EXIST "%~dp0aact\online\AAct_Network.exe" GOTO restoreactivators
	ECHO -- Abriendo activador ONLINE --
	ECHO -- Script continuara al cerrar el activador --
	start /WAIT "" "%~dp0aact\online\AAct_Network.exe"
	GOTO driverpack

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
	start /WAIT chrome /incognito "https://www.onlinemictest.com/es/prueba-de-teclado/" " https://es.mictests.com" "https://www.youtube.com"
	ECHO -- Paginas abiertas --
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
	EXIT

	:: == NO IMPLEMENTADO EN SCRIPT ==

	:reminders
	:: Esta seccion muestra los recordatorios de pruebas de hardware
	ECHO.
	ECHO -- Antes de terminar, por favor revise los puertos USB y las salidas de video (VGA, HDMI) --
	PAUSE

	:summary
	:: En esta seccion se hace el resumen de configuracion del equipo
	ECHO.
	ECHO  === RESUMEN ===
	ECHO.
	CHOICE /C:Y /CS /M -- Presione "Y" para continuar...


	:: == UTILIDADES ==

	:restoreactivators
	:: Script para restaurar activadores
	ECHO -- Activadores desaparecidos, restaurando...
	tar -xf aact\Respaldo.zip -C aact > nul
	ECHO -- Restauracion completa --
	TIMEOUT 4 /nobreak > nul
	if %connected% == "0" GOTO kmsonline
	GOTO kmsoffline

	:detect-type
	:: Script para determinar el tipo de equipo y las pruebas a hacer
	ECHO.
	ECHO -- Detectando tipo de equipo --
	set /a "chassNum=0" 
	set "command=2^>nul WMIC SystemEnclosure Get ChassisTypes /value" 
	for /f "tokens=2 delims=={}" %%A IN ('%command%') do ( 
	2>nul set /a "chassNum=%%A"
	CALL :CASE_%chassNum%

	:: == MENUS ==


	::COMENTARIOS

	::COMANDOS
	:: -getNameCPU&MaxClock wmic cpu get name, maxclockspeed
	:: -

	:: == GENERAL ==
	:: VER MANERA DE VERIFICAR QUE OFFICE Y WINDOWS ESTEN ACTIVADOS AL FINAL
	:: RECORDATORIOS DE PRUEBAS DE HARDWARE
	:: MODIFICAR PRUEBA DE SONIDO OFFLINE
	:: AGREGAR INFORMACION DE TARJETA GRAFICA (NOMBRE, CANTIDAD DE ADAPTADORES, MEMORIA DEDICADA)
	:: AGREGAR RESUMEN DE CONFIGURACION DE EQUIPO AL FINAL EN CONJUNTO A MARCA Y MODELO
	:: IMPLEMENTAR SI EQUIPO ES ESCRITORIO O LAPTOP (wmic systemenclosure get chassistypes)
	:: AGREGAR CHECKLIST DE PASOS

	:: == ESCRITORIO ==
	:: DESARROLLAR PRUEBAS MEDIA PARA ESCRITORIO (SALTAR MICROFONO)
	:: AGREGAR JUEGOS PARA PRUEBA GAMER

	:: == LAPTOP ==
	:: PRUEBAS PARA MOUSE Y CLICKS (DETECTAR DOBLE CLICK EN LAPTOPS)

	:: < BUGS - ESTA ITERACION >
	:: - Realizar chequeo de red en mediatest (hacer una reconexion)

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
	:: AGREGAR SISTEMA DE REPORTES POR EQUIPO



	:: >> IDEAS <<
	:: Script para clonacion de HDD
	:: Scipt post-formateo (Tipo WIPI) - WIP (OFFICE 2019/2016 - ACROBAT DC - VLC - CHROME - WINRAR x86/64)

	  