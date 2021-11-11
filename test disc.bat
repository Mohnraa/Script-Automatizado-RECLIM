@Echo off
 ECHO == Iniciando preparacion normal, presione cualquier tecla para mas opciones ==
 For /L %%i in (30 -1 1)Do (
  For /F "Delims=" %%G in ('Choice /T 1 /N /C:0123456789qwertyuiopasdfghjklzxcvbnm /D 0')Do (
   If %ERRORLEVEL% GTR 1 ECHO == Cancele cuenta y entre menu && PAUSE && EXIT
  )
 )
 ECHO -- SE INICIO PROCESO NORMAL
 PAUSE




