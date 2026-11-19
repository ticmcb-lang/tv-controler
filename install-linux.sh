#!/bin/bash
# TV-Controler - Instalador Automático para Linux (Ubuntu, Debian, Raspberry Pi, etc.)
set -euo pipefail

cd "$(dirname "$0")"

echo "========================================================"
echo "        TV-Controler - Instalación en Linux"
echo "========================================================"
echo ""

# 1. Comprobar Node.js
if ! command -v node >/dev/null 2>&1; then
    echo "[AVISO] Node.js no se encuentra instalado en este sistema."
    echo ""
    if command -v docker >/dev/null 2>&1; then
        echo "Se ha detectado Docker. ¿Deseas ejecutar TV-Controler con Docker? (s/n)"
        read -r USE_DOCKER
        if [[ "$USE_DOCKER" =~ ^[Ss]$ ]]; then
            ./run-docker.sh
            exit 0
        fi
    fi
    echo "Para instalar Node.js 20 LTS en Debian/Ubuntu ejecuta:"
    echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
    echo "  sudo apt-get install -y nodejs build-essential ffmpeg"
    echo ""
    exit 1
fi

echo "[OK] Node.js detectado: $(node -v)"
echo "[OK] npm detectado:     $(npm -v)"
echo ""

# 2. Configurar .env si no existe
if [ ! -f .env ] && [ -f .env.example ]; then
    echo "Generando archivo .env inicial desde .env.example..."
    cp .env.example .env
fi

# 3. Crear directorios de datos
mkdir -p server/db server/uploads/content server/uploads/screenshots server/uploads/fonts

# 4. Instalar dependencias del servidor
echo "Instalando dependencias de producción en server/..."
cd server
npm ci --omit=dev || npm install --omit=dev || npm install
cd ..

echo ""
echo "========================================================"
echo "  ¡Instalación de dependencias completada con éxito!"
echo "========================================================"
echo ""
echo "¿Deseas instalar TV-Controler como servicio del sistema (systemd) para que inicie automáticamente al encender? (s/n)"
read -r INSTALL_SRV
if [[ "$INSTALL_SRV" =~ ^[Ss]$ ]]; then
    bash scripts/install-service.sh
else
    echo ""
    echo "Para iniciar el servidor manualmente ejecuta:"
    echo "  npm start"
    echo "  O también: cd server && node server.js"
    echo ""
    echo "¿Deseas iniciar el servidor ahora? (s/n)"
    read -r START_NOW
    if [[ "$START_NOW" =~ ^[Ss]$ ]]; then
        cd server && node server.js
    fi
fi
