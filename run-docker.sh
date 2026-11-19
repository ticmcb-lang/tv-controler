#!/bin/bash
# TV-Controler - Docker Runner for Linux/macOS
set -euo pipefail

cd "$(dirname "$0")"

echo "========================================================"
echo "        TV-Controler - Despliegue con Docker"
echo "========================================================"
echo ""

if ! command -v docker >/dev/null 2>&1; then
    echo "[ERROR] Docker no está instalado en el sistema." >&2
    echo "Instala Docker o Docker Engine antes de continuar." >&2
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "[ERROR] El daemon de Docker no está en ejecución o no tienes permisos de sudo/docker group." >&2
    echo "Prueba con: sudo systemctl start docker" >&2
    exit 1
fi

echo "Compilando e iniciando contenedores locales..."
if docker compose version >/dev/null 2>&1; then
    docker compose up -d --build
else
    docker-compose up -d --build
fi

echo ""
echo "========================================================"
echo "  TV-Controler iniciado correctamente en Docker!"
echo "========================================================"
echo ""
echo "URL del panel de control: http://localhost:3001"
echo "Para ver logs en tiempo real: docker compose logs -f"
echo "Para detener el servicio:      docker compose down"
echo ""
