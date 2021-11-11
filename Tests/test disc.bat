    @ECHO OFF
    ECHO.
    ECHO                         ---=== MENU PRINCIPAL ===---
    ECHO.
    ECHO - [1]: Proceso de preparacion normal
    ECHO        (Activacion W10-Office + DriverPack + Pruebas Teclado-Camara-Sonido-CD)
    ECHO - [2]: Proceso de preparacion rapida
    ECHO        (Activacion W10-Office, DriverPack)
    ECHO - [3]: Preparacion desde cero
    ECHO        (Instalacion Programas/Office 2019 + Preparacion normal)
    ECHO - [4]: Continuar preparacion desde cualquier paso
    ECHO - [5]: Herramientas de Diagnostico / Reparacion
    ECHO.
    ECHO - [0]: SALIR
    ECHO.
    TIMEOUT 2 /nobreak > nul
    CHOICE /c:123450 /N /M "Opcion Seleccionada:"

