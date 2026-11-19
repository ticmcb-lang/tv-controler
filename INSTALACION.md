# Guía de Instalación y Despliegue en Cualquier Entorno: TV-Controler

Esta guía detalla los pasos para instalar y poner en marcha **TV-Controler** en cualquier entorno (computadoras Windows, servidores Linux, Raspberry Pi, o mediante contenedores Docker).

---

## 🚀 Métodos de Instalación Disponibles

Puedes elegir el método que mejor se adapte a tu nuevo entorno:

1. [Método 1: Docker (Universal y Recomendado)](#método-1-docker-recomendado-y-universal)
2. [Método 2: Instalación Nativa en Windows](#método-2-instalación-nativa-en-windows)
3. [Método 3: Instalación Nativa en Linux / Debian / Ubuntu / Raspberry Pi](#método-3-instalación-nativa-en-linux--debian--ubuntu--raspberry-pi)

---

## Método 1: Docker (Recomendado y Universal)

Este método funciona exactamente igual en **Windows**, **Linux** y **macOS**, aislando todas las dependencias (Node.js, ffmpeg, SQLite) en un contenedor limpio.

### Requisitos:
- Tener instalado **Docker** y **Docker Compose** (en Windows, tener abierto Docker Desktop).

### Pasos:

#### En Windows:
1. Haz doble clic en el archivo `run-docker.bat` o abre PowerShell/CMD en esta carpeta y ejecuta:
   ```cmd
   docker compose up -d --build
   ```
2. Abre tu navegador en: **`http://localhost:3001`**

#### En Linux / macOS:
1. Dale permisos de ejecución y corre el script:
   ```bash
   chmod +x run-docker.sh
   ./run-docker.sh
   ```
   *(O directamente: `docker compose up -d --build`)*
2. Abre tu navegador en: **`http://localhost:3001`**

#### Comandos Útiles de Docker:
- **Ver logs en tiempo real:** `docker compose logs -f`
- **Detener el sistema:** `docker compose down`
- **Reiniciar el sistema:** `docker compose restart`
- **Persistencia:** Todos los datos (base de datos, usuarios, playlists, videos y fotos) se guardan de forma permanente en el volumen Docker `st-data`.

---

## Método 2: Instalación Nativa en Windows

Para instalarlo directamente en una máquina con Windows sin Docker:

### Requisitos:
- Descargar e instalar **Node.js 20 LTS** desde [https://nodejs.org/](https://nodejs.org/). *(Asegúrate de marcar la casilla para agregarlo al PATH durante la instalación)*.

### Pasos:
1. Haz doble clic en el script automatizado:
   ```cmd
   install-windows.bat
   ```
   Este instalador:
   - Valida la versión de Node.js.
   - Crea el archivo de configuración `.env` si no existe.
   - Instala todas las dependencias del servidor automáticamente.
   - Prepara las carpetas de base de datos y subida de archivos.
2. Para iniciar la aplicación en cualquier momento, simplemente haz doble clic en:
   ```cmd
   iniciar-tv-controler.bat
   ```
   *(O desde la terminal ejecuta: `npm start`)*.
3. Abre tu navegador en: **`http://localhost:3001`**.

---

## Método 3: Instalación Nativa en Linux / Debian / Ubuntu / Raspberry Pi

Para instalarlo en un servidor o mini-PC con Linux:

### Requisitos Previos:
Instalar Node.js 20 LTS, herramientas de compilación y ffmpeg:
```bash
# En Debian / Ubuntu / Raspberry Pi OS:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs build-essential ffmpeg
```

### Pasos:
1. Otorga permisos de ejecución al instalador y ejecútalo:
   ```bash
   chmod +x install-linux.sh scripts/*.sh
   ./install-linux.sh
   ```
2. El script instalará las dependencias y te preguntará si deseas configurarlo como **servicio del sistema (systemd)** para que inicie automáticamente cuando el equipo encienda.

### Comandos del Servicio Systemd (si lo instalaste como servicio):
- **Ver estado:** `sudo systemctl status tv-controler`
- **Reiniciar:** `sudo systemctl restart tv-controler`
- **Detener:** `sudo systemctl stop tv-controler`
- **Ver logs en vivo:** `sudo journalctl -u tv-controler -f`

---

## ⚙️ Configuración y Variables de Entorno (.env)

El archivo `.env` en la raíz del proyecto permite personalizar el funcionamiento:

```ini
# Puerto en el que escuchará el servidor (por defecto 3001)
PORT=3001

# Modo autoservicio (sin llamadas externas ni cobros)
SELF_HOSTED=true
HIDE_BILLING=true
DISABLE_HOMEPAGE=true

# Desactiva chequeos de actualización remota
OTA_ENABLED=false
```

Si necesitas cambiar el puerto porque el 3001 está ocupado, simplemente cambia `PORT=3002` en el `.env`. Tanto la ejecución nativa como Docker respetarán este puerto automáticamente.

---

## 💾 Dónde se Guardan tus Datos y Respaldos

- **Base de Datos:** Se almacena en formato SQLite en `server/db/remote_display.db` (o dentro de `/data/db/` en Docker).
- **Archivos Subidos (Videos, Imágenes, Pantallas):** En `server/uploads/` (o `/data/uploads/` en Docker).
- **Para hacer un respaldo rápido:** Solo necesitas copiar la carpeta `server/db/` y `server/uploads/` (o el volumen de Docker).
