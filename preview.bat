@echo off
chcp 65001 >nul
cd /d "%~dp0"

REM Pick an available Python interpreter
set "PY=python"
where python >nul 2>nul
if errorlevel 1 set "PY=C:\Users\zhangjingyue-ghq\.workbuddy\binaries\python\versions\3.13.12\python.exe"

echo ==================================================
echo   Bond Yield Curve Site - Local Preview Server
echo ==================================================
echo Browser will open: http://localhost:8000/
echo To stop the server: close this window or press Ctrl+C
echo.

start "" http://localhost:8000/
"%PY%" -m http.server 8000

echo.
echo Server stopped. Press any key to close this window.
pause >nul
