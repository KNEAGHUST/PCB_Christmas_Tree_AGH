@echo off
setlocal enabledelayedexpansion

REM Get all COM ports and store them in a list
set "COMPORTS="
for /f "tokens=*" %%A in ('powershell -Command "[System.IO.Ports.SerialPort]::GetPortNames()"') do (
    set "COMPORTS=!COMPORTS! %%A"
    set /a COUNT+=1
)

REM Check if any COM ports were found
if "%COUNT%"=="0" (
    echo Brak portow COM.
    exit /b
)

REM If only one COM port is found, use it directly
if "%COUNT%"=="1" (
    for %%A in (%COMPORTS%) do set "USER_COMPORT=%%A"
    echo Found one available COM port: %USER_COMPORT%
) else (
    REM Display the COM ports and prompt the user to select one if there are multiple
    echo Available COM ports: %COMPORTS%
    set /p USER_COMPORT="Prosze wybrac COM port (np. COM3): "
    
    REM Verify the user's selection
    if not defined USER_COMPORT (
        echo Brak portow COM.
        exit /b
    )
)

REM Run the Python script with the chosen COM port
python pyupdi-master\updi\pyupdi.py -d tiny402 -c %USER_COMPORT% -f CTree.hex -v
