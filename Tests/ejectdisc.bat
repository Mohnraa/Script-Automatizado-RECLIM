@ECHO OFF
For /L %%i in (10 -1 1)Do (
  For /F "Delims=" %%G in ('Choice /T 1 /N /C:0123456789h /D h')Do (
   Cls
   type logo.txt
   ECHO == Iniciando preparacion normal en %%i segundos, presione 0 para empezar o [1-9] para mas opciones ==
   IF %%i LEQ 4 IF %%i GTR 1 call powershell "[console]::beep(500,600)"
   IF %%i EQU 1 call powershell "[console]::beep(990,600)"
   IF %%G EQU 0 GOTO cad
   IF %%G GTR 0 IF %%G LSS 10 GOTO num
  )
 )
GOTO _off

:start
ECHO == INICIO FORZADO ==
PAUSE
EXIT

:menu
ECHO == MENU ==
PAUSE
EXIT

:_off
ECHO == INICIO POR TIMEOUT BY JEFE MAESTRO==
PAUSE
EXIT