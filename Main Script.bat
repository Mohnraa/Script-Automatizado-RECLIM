	@ECHO OFF
	title Script Activador de RECLIM 0.1 BETA

	:: INICIADOR DE VARIABLES

	:intro
	 For /L %%i in (10 -1 1)Do (
  	  For /F "Delims=" %%G in ('Choice /T 1 /N /C:0123456789h /D h')Do (
       Cls
   	   type "%~dp0logo.txt"
       ECHO 	== Iniciando preparacion normal en %%i segundos, presione 0 para empezar o [1-9] para mas opciones ==
       IF %%i LEQ 4 IF %%i GTR 1 call powershell "[console]::beep(500,600)"
       IF %%i EQU 1 call powershell "[console]::beep(990,600)"
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
	ECHO !! Precaucion: Conexion a internet no detectada !!
	TIMEOUT /T 3 /NOBREAK > nul
	SET connected="1"
	goto kmsoffline

	:kmsoffline
	:: Esta seccion maneja el activador sin internet
	IF NOT EXIST "%~dp0aact\offline\AAct.exe" GOTO restoreactivators
	ECHO.
	ECHO -- Abriendo activador OFFLINE --
	ECHO -- Script continuara al cerrar el activador --
	start /WAIT "" "%~dp0aact\offline\AAct.exe"
	GOTO driverpack

	:kmsonline
	::Esta seccion abre los activadores
	IF NOT EXIST "%~dp0aact\online\AAct_Network.exe" GOTO restoreactivators
	ECHO.
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
	GOTO reminders

	:reminders
	:: Esta seccion muestra los recordatorios de pruebas de hardware
	ECHO.
	ECHO -- Antes de terminar, por favor revise los puertos USB y las salidas de video (VGA, HDMI, DP) --
	PAUSE
	EXIT

	:: == UTILIDADES ==

	:restoreactivators
	:: Script para restaurar activadores
	ECHO.
	ECHO -- Activadores desaparecidos, restaurando...
	tar -xf "%~dp0aact\Respaldo.zip" -C "%~dp0aact" > nul
	IF NOT EXIST "%~dp0aact\online\AAct_Network.exe" ECHO !! ERROR: RESTAURACION FALLIDA, REINTENTANDO !! && TIMEOUT 4 /nobreak > nul && GOTO restoreactivators
	IF NOT EXIST "%~dp0aact\offline\AAct.exe" ECHO !! ERROR: RESTAURACION FALLIDA, REINTENTANDO !! && TIMEOUT 4 /nobreak > nul && GOTO restoreactivators	
	ECHO -- Restauracion completa --
	TIMEOUT 4 /nobreak > nul
	if %connected% == "0" GOTO kmsonline
	GOTO kmsoffline

	:mediacheck
	:: Esta seccion verifica si existe una conexion a internet
	ECHO.
	ECHO -- Verificando conexion a internet --
	ping 1.1.1.1 > nul
	if "%errorlevel%" == "0" (SET connected="0" && ECHO -- Conexion detectada, continuando -- && goto mediatest)
	ECHO !! Precaucion: Conexion a internet no detectada !!
	TIMEOUT /T 3 /NOBREAK > nul
	SET connected="1"
	goto mediatestoffline

	:: == NO IMPLEMENTADO EN SCRIPT ==

	:summary
	:: En esta seccion se hace el resumen de configuracion del equipo
	ECHO.
	ECHO  === RESUMEN ===
	ECHO.
	CHOICE /C:Y /CS /M -- Presione "Y" para continuar...

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

	:: == MENUS ==
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
	TIMEOUT 2 /nobreak > nul
	CHOICE /c:123450 /N /M "Opcion Seleccionada: "
	IF %ERRORLEVEL% EQU 6 EXIT
	IF %ERRORLEVEL% EQU 1 GOTO antivirus
	IF %ERRORLEVEL% EQU 2 GOTO antivirus
	IF %ERRORLEVEL% EQU 3 GOTO antivirus
	IF %ERRORLEVEL% EQU 4 GOTO steps-menu
	IF %ERRORLEVEL% EQU 5 ECHO -- NO IMPLEMENTADO -- && PAUSE && GOTO intro

	:steps-menu
	Cls
	ECHO.
	ECHO						 ---=== MENU DE PASOS ===---
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
	ECHO - [0]: REGRESAR A MENU PRINCIPAL
	ECHO.
	TIMEOUT 2 /nobreak > nul
	CHOICE /c:12345670 /N /M "Opcion Seleccionada: "
	IF %ERRORLEVEL% EQU 1 GOTO antivirus
	IF %ERRORLEVEL% EQU 2 GOTO webtest
	IF %ERRORLEVEL% EQU 3 GOTO driverpack
	IF %ERRORLEVEL% EQU 4 GOTO mediacheck
	IF %ERRORLEVEL% EQU 5 GOTO cameratest
	IF %ERRORLEVEL% EQU 6 GOTO cdtest
	IF %ERRORLEVEL% EQU 8 GOTO main-menu





	::COMENTARIOS

	::COMANDOS
	:: -getNameCPU&MaxClock wmic cpu get name, maxclockspeed
	:: -

	:: == GENERAL ==
	:: CAMBIAR DIRECTORIOS RELATIVOS PARA EJECUTAR COMO ADMINISTRADOR
	:: AGREGAR EN REMINDERS SOBRE LA BATERIA EN LAPTOPS
	:: VER MANERA DE VERIFICAR QUE OFFICE Y WINDOWS ESTEN ACTIVADOS AL FINAL
	:: RECORDATORIOS DE PRUEBAS DE HARDWARE
	:: MODIFICAR PRUEBA DE SONIDO OFFLINE
	:: AGREGAR INFORMACION DE TARJETA GRAFICA (NOMBRE, CANTIDAD DE ADAPTADORES, MEMORIA DEDICADA)
	:: AGREGAR RESUMEN DE CONFIGURACION DE EQUIPO AL FINAL EN CONJUNTO A MARCA Y MODELO
	:: IMPLEMENTAR SI EQUIPO ES ESCRITORIO O LAPTOP (wmic systemenclosure get chassistypes)
	:: AGREGAR CHECKLIST DE PASOS AL FINAL
	:: -NOTA: WINDOS 10 20H2 NO PERMITE INSTALAR DRIVERS POR DEVICE MANAGER

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
	:: AGREGAR MODO RAPIDO DE PREPARACION DE EQUIPOS
	:: VERIFICAR SI LOS ACTIVADORES HICIERON SU TRABAJO, SI NO REABRIRLOS
	:: AGREGAR VARIABLES BANDERA PARA CAMBIAR EL FLUJO DE PREPARACION SEGUN TIPO DE PREPARACION Y EQUIPO
	:: AGREGAR CAMINO PARA VIEJA Y NUEVA IMAGEN (REMOVER DEVICE MANAGER EN NUEVA IMAGEN)


	:: >> IDEAS <<
	:: Script para clonacion de HDD
	:: Scipt post-formateo (Tipo WIPI) - WIP (OFFICE 2019/2016 - ACROBAT DC - VLC - CHROME - WINRAR x86/64)

	  