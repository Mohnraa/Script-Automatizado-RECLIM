@echo off
goto :GetVideoMemorySize

rem Note: MB = MiB and GB = GiB in this batch file, see
rem       https://en.wikipedia.org/wiki/Byte for details on GiB.

rem The command WMIC with the parameters PATH Win32_videocontroller GET
rem AdapterRAM outputs one line per video adapter. The output of WMIC is
rem in UTF-16 LE with BOM. The output is redirected to a temporary file
rem which is printed by command TYPE to STDOUT which makes a better job
rem on UNICODE to ASCII conversion as command FOR.

rem Memory of a video adapter is in bytes which can be greater 2^31 (= 2 GB).
rem Windows command processor performs arithmetic operations always with
rem 32-bit signed integer. Therefore 2 GB or more installed video memory
rem exceeds the bit width of a 32-bit signed integer and arithmetic
rem calculations are wrong on 2 GB or more installed video memory. To
rem avoid the integer overflow, a subroutine is called which makes the
rem calculation depending on string value length, i.e. number of bits.

rem Create a copy of current environment variables. Enabling additionally
rem delayed environment variable expansion is not required for this task.
rem Command extensions are enabled by default, but nevertheless enable it.

:GetVideoMemorySize
setlocal EnableExtensions
set "VideoTotalMemory=0"
set "VideoAdapterCount=0"

%SystemRoot%\System32\wbem\wmic.exe PATH Win32_videocontroller GET AdapterRAM >"%TEMP%\AdapterRam.tmp"

for /F "skip=1" %%M in ('type "%TEMP%\AdapterRam.tmp"') do (
    set /A VideoAdapterCount+=1
    set "VideoAdapterMemory=%%M"
    call :AddVideoMemory
)
del "%TEMP%\AdapterRam.tmp"

if "%VideoAdapterCount%" == "1" (
    set "AdapterInfo="
) else (
    set "AdapterInfo= of %VideoAdapterCount% video adapters"
)

echo Total video memory is: %VideoTotalMemory% MB%AdapterInfo%
echo.
if %VideoTotalMemory% LEQ 1024 (
    echo Low Graphics memory
) else (
    echo Supported
)

endlocal
goto :EOF

rem This subroutine calculates the total video adapter memory correct
rem only for video adapter memory sizes being either less than 1 GB or
rem an exact multiple of 1 GB. The calculation is wrong for values like
rem 1.5 GB, 2.5 GB and similar values.

rem For a value with not more than 9 characters the memory size in MB
rem can be directly calculated with a division by 1024 * 1024 = 1048576.

rem To avoid an integer overflow on video memory sizes of 1 GB and more,
rem the last 6 characters are removed from bytes value and the remaining
rem characters are divided by 1073 to get the number of GB which is next
rem multiplied with 1024 to get the value in MB.

rem  1 GB =  1.073.741.824 bytes = 2^30
rem  2 GB =  2.147.483.648 bytes = 2^31
rem  4 GB =  4.294.967.296 bytes = 2^32
rem  8 GB =  8.589.934.592 bytes = 2^33
rem 16 GB = 17.179.869.184 bytes = 2^34
rem 32 GB = 34.359.738.368 bytes = 2^35

:AddVideoMemory
if not "%VideoAdapterMemory:~9,1%" == "" goto AtLeast1GB
set /A VideoTotalMemory+=VideoAdapterMemory/1048576
goto :EOF

:AtLeast1GB
set "VideoAdapterMemory=%VideoAdapterMemory:~0,-6%"
set /A VideoTotalMemory+=(VideoAdapterMemory/1073)*1024
goto :EOF