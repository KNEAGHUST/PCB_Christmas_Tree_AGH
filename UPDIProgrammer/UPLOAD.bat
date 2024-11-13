@echo off
for /f "tokens=*" %%A in ('powershell -Command "[System.IO.Ports.SerialPort]::GetPortNames() | Select-Object -First 1"') do (
    set COMPORT=%%A
)
if defined COMPORT (
    echo Found available com port: %COMPORT%
) else (
    echo No COM ports found.
)

setlocal

python pyupdi-master\updi\pyupdi.py -d tiny402 -c %COMPORT% -f CTree.hex -v