@echo off
REM Sarcoin SRS - Environment Setup
REM Run this before any Sarcoin command to ensure proper environment

echo Setting up Sarcoin environment...

REM Add MinGW to PATH
set PATH=C:\msys64\mingw64\bin;%PATH%

REM Enable CGO
set CGO_ENABLED=1

echo.
echo Environment configured:
echo   - MinGW-w64 GCC added to PATH
echo   - CGO enabled
echo.
echo You can now run Sarcoin commands:
echo   .\build\bin\geth.exe version
echo   .\start-testnet.ps1
echo   .\test-rpc.ps1
echo.

REM Start PowerShell with environment
powershell.exe -NoExit
