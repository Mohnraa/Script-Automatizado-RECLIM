@echo off
:: Mover directorio actual a carpeta Office
cd /d %ProgramFiles%\Microsoft Office\Office16

::Instalar licencias para Office 2021 Pro Plus VL
for /f %x in ('dir /b ..\root\Licenses16\ProPlus2021VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%x"

::Seleccionar puerto de servidor KMS a 1688
cscript ospp.vbs /setprt:1688

::Desinstalar clave predeterminada por instalacion
cscript ospp.vbs /unpkey:6F7TH >nul

::Instalar nueva clave de Suite
cscript ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH

::Configurar nombre de servidor KMS
cscript ospp.vbs /sethst:s8.now.im

::Realizar la activacion
cscript ospp.vbs /act