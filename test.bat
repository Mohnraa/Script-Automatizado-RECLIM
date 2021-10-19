
	@ECHO OFF
	title Script Activador de RECLIM

	:intro
	ECHO.
	type logo.txt
	ECHO.
	TIMEOUT 6
	GOTO antivirus

	:antivirus
	::Esta seccion abre Seguridad de Windows
	ECHO.
	ECHO -- Abriendo Windows Defender --
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
	TIMEOUT 5
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
	::start /WAIT "" "%~dp0DriverPack.G\DriverPack"
	if %connected% == "0" GOTO mediatest
	GOTO mediatestoffline

	:mediatest
	ECHO.
	:: Esta seccion abre paginas de prueba de teclado, microfno y bocinas
	ECHO -- Abriendo paginas de prueba de bocinas, microfono y teclado --
	start /WAIT chrome /incognito "https://www.onlinemictest.com/es/prueba-de-teclado/" " https://es.mictests.com" "https://www.youtube.com"
	ECHO -- Paginas abiertas!
	PAUSE
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
	EXIT
	
	:cdtest
	:: Esta seccion prueba el funcionamiento de lectora de CD (si existe)

	:: == UTILIDADES ==

	:restoreactivators
	:: Script para restaurar activadores
	ECHO -- Activadores desaparecidos, restaurando...
	tar -xf aact\Respaldo.zip -C aact
	ECHO -- Restauracion completa --
	TIMEOUT 3
	if %connected% == "0"GOTO kmsonline
	GOTO kmsoffline


	::COMENTARIOS
	:: COMBROBAR MANERA DE VERIFICAR LECTORA DE DISCOS
	:: AGREGAR MENU AL INICIO DE SCRIP PARA SALTAR A CIERTO PASO
	:: AGREGAR RESUMEN DE CONFIGURACION DE EQUIPO AL FINAL
	:: REVISAR SI EL DISCO FUE EXPANDIDO
	:: REVISAR ASUTO DE PERMISOS DE ADMINISTRADOR
	:: AGREGAR JUEGOS PARA PRUEBA GAMER
	:: AGREGAR CASOS EN CASO QUE CIERTOS PROGRAMAS NO ESTAN INSTALADOS
	:: VER MANERA QUE OFFICE Y WINDOWS ESTEN ACTIVADOS AL FINAL POR CMD
	  