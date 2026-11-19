@echo off
title TV-Controler - Servidor de Senalizacion Digital
cd /d "%~dp0"

echo ========================================================
echo             Iniciando TV-Controler
echo ========================================================
echo.

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado o no se encuentra en el PATH.
    echo Ejecuta primero install-windows.bat o instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

if not exist server\node_modules (
    echo [AVISO] Las dependencias no estan instaladas. Ejecutando instalacion previa...
    call install-windows.bat
)

echo Iniciando servidor en puerto 3001...
echo La interfaz estara disponible en: http://localhost:3001
echo.
echo Presiona Ctrl+C para detener el servidor.
echo.

REM Inicia el servidor Node
cd server
node server.js

pause
