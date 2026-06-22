#!/usr/bin/env bash
# Sincroniza la presentación al VPS (carpeta servida por nginx/caddy/http.server).
# Editar estas 3 variables segun tu setup en el VPS:
set -euo pipefail

VPS_USER="claude-code"
VPS_HOST="72.61.221.201"
# Carpeta destino en el VPS que sirve el servidor web:
DEST="/home/${VPS_USER}/sites/protocolo-oxigenoterapia"

SRC="$(cd "$(dirname "$0")" && pwd)/public/"

echo ">> Sincronizando ${SRC} -> ${VPS_USER}@${VPS_HOST}:${DEST}"
ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p '${DEST}'"
rsync -avz --delete "${SRC}" "${VPS_USER}@${VPS_HOST}:${DEST}/"

echo ">> Listo. Sirve esa carpeta en el VPS, por ejemplo:"
echo "   ssh ${VPS_USER}@${VPS_HOST} 'cd ${DEST} && python3 -m http.server 8090'"
echo "   y comparte por WhatsApp la URL: http://${VPS_HOST}:8090/"
