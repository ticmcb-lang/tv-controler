#!/bin/bash
# TV-Controler - Script de Actualización Segura en Proxmox CT (Conserva Base de Datos y Videos)
set -euo pipefail

cd "$(dirname "$0")"

echo "========================================================"
echo "     TV-Controler - Actualización en Proxmox CT"
echo "========================================================"
echo ""

# 1. Asegurar permisos de ejecución en scripts
chmod +x *.sh scripts/*.sh 2>/dev/null || true

# 2. Detectar si está corriendo con Docker Compose
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    if docker ps -a --format '{{.Names}}' | grep -Eq 'tv-controler|screentinker'; then
        echo "[Detectado] Despliegue en Docker activo."
        echo "Recompilando imagen con los nuevos cambios (conservando volumen de datos st-data)..."
        if docker compose version >/dev/null 2>&1; then
            docker compose up -d --build
        else
            docker-compose up -d --build
        fi
        echo ""
        echo "Limpiando imágenes antiguas huérfanas..."
        docker image prune -f >/dev/null 2>&1 || true
        echo ""
        echo "========================================================"
        echo "  ¡Actualización en Docker completada con éxito!"
        echo "========================================================"
        docker ps --filter "name=tv-controler"
        exit 0
    fi
fi

# 3. Si no hay contenedor previo pero Docker está instalado y no hay systemd nativo
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1 && ! systemctl list-unit-files | grep -Eq 'tv-controler|screentinker|remotedisplay'; then
    echo "[Detectado] Entorno Docker disponible."
    echo "Levantando contenedor TV-Controler..."
    if docker compose version >/dev/null 2>&1; then
        docker compose up -d --build
    else
        docker-compose up -d --build
    fi
    echo ""
    echo "========================================================"
    echo "  ¡TV-Controler desplegado y actualizado con éxito!"
    echo "========================================================"
    exit 0
fi

# 4. Modo Nativo en el CT (Systemd / Node.js directo)
echo "[Detectado] Instalación nativa en Linux."
mkdir -p server/db server/uploads/content server/uploads/screenshots server/uploads/fonts

if [ ! -d "server/node_modules" ]; then
    echo "Instalando dependencias en server/..."
    cd server
    npm ci --omit=dev || npm install --omit=dev || npm install
    cd ..
fi

# Reiniciar el servicio systemd correspondiente si existe
for SVC in tv-controler screentinker-server remotedisplay; do
    if systemctl list-unit-files | grep -q "^${SVC}.service"; then
        echo "Reiniciando servicio del sistema: ${SVC}..."
        sudo systemctl restart "$SVC"
        sudo systemctl status "$SVC" --no-pager
        echo ""
        echo "========================================================"
        echo "  ¡Servicio ${SVC} actualizado y reiniciado con éxito!"
        echo "========================================================"
        exit 0
    fi
done

echo ""
echo "No se detectó servicio previo corriendo. Instalando servicio systemd..."
bash scripts/install-service.sh
