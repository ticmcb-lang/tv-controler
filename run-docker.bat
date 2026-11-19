@echo off
title TV-Controler - Docker Runner
cd /d "%~dp0"

echo ========================================================
echo        TV-Controler - Despliegue con Docker
echo ========================================================
echo.

where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Docker no esta instalado o no se encuentra en el PATH.
    echo Asegurate de tener Docker Desktop abierto y en ejecucion.
    pause
    exit /b 1
)

echo Verificando si Docker esta en ejecucion...
docker info >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] El servicio de Docker (Docker Desktop) no esta iniciado.
    echo Por favor inicia Docker Desktop y vuelve a intentar.
    pause
    exit /b 1
)

echo Compilando e iniciando contenedores locales...
docker compose up -d --build

echo.
echo ========================================================
echo   TV-Controler iniciado correctamente en Docker!
echo ========================================================
echo.
echo URL del panel de control: http://localhost:3001
echo Para ver los logs en tiempo real: docker compose logs -f
echo Para detener el servicio:          docker compose down
echo.
pause
