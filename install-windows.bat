@echo off
setlocal enabledelayedexpansion
title TV-Controler - Instalador para Windows

echo ========================================================
echo        TV-Controler - Instalacion y Configuracion
echo ========================================================
echo.

cd /d "%~dp0"

REM 1. Verificar si Node.js esta instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [AVISO] Node.js no se detecto en el PATH del sistema.
    echo.
    echo Opciones:
    echo 1. Si tienes Docker instalado, puedes ejecutar TV-Controler con Docker.
    echo 2. Si prefieres ejecutarlo nativo, descarga e instala Node.js 20 LTS desde:
    echo    https://nodejs.org/
    echo.
    where docker >nul 2>nul
    if %errorlevel% equ 0 (
        echo Se detecto Docker en tu sistema. Deseas iniciar con Docker? (S/N)
        set /p USE_DOCKER="> "
        if /i "!USE_DOCKER!"=="S" (
            call run-docker.bat
            goto end
        )
    )
    echo Presiona cualquier tecla para salir...
    pause >nul
    exit /b 1
)

echo [OK] Node.js detectado:
node -v
npm -v
echo.

REM 2. Crear archivo .env si no existe
if not exist .env (
    if exist .env.example (
        echo Creando archivo de configuracion .env desde .env.example...
        copy .env.example .env >nul
    )
)

REM 3. Instalar dependencias del servidor
echo ========================================================
echo   Instalando dependencias del servidor (server)...
echo ========================================================
cd server
call npm install --omit=dev
if %errorlevel% neq 0 (
    echo.
    echo [ADVERTENCIA] 'npm install --omit=dev' tuvo incidencias. Reintentando con 'npm install'...
    call npm install
)
cd ..

REM 4. Crear carpetas necesarias
if not exist server\db mkdir server\db
if not exist server\uploads\content mkdir server\uploads\content
if not exist server\uploads\screenshots mkdir server\uploads\screenshots
if not exist server\uploads\fonts mkdir server\uploads\fonts

echo.
echo ========================================================
echo   Instalacion completada con exito!
echo ========================================================
echo.
echo Para iniciar TV-Controler puedes:
echo  - Ejecutar: iniciar-tv-controler.bat
echo  - O ejecutar: npm start
echo.
echo Deseas iniciar el servidor ahora mismo? (S/N)
set /p START_NOW="> "
if /i "%START_NOW%"=="S" (
    call iniciar-tv-controler.bat
)

:end
