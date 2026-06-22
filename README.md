# Protocolo Oxigenoterapia — TEVEUCI

Presentación web de 5 láminas (protocolo de oxígeno domiciliario) lista para
servirse **online** y abrirse desde cualquier celular (Android **e iOS**) con
solo compartir una **URL** por WhatsApp.

## Estructura

```
protocolo-oxigenoterapia/
├── docs/
│   └── index.html      # La presentación (versión corregida para iOS)
├── deploy.sh           # Sincroniza docs/ al VPS por rsync
└── README.md
```

> Se usa `docs/` (no `public/`) porque GitHub Pages sirve esa carpeta de forma
> nativa sin necesidad de workflows ni permisos extra.

## Clave de la lámina 5 (acceso restringido)

`TEVEUCI00`

## Qué se arregló para iOS (vs. el HTML original)

El original funcionaba en Android pero "se desconfiguraba" en iPhone. Causas y fix:

1. **`100vh` (`min-h-screen`)** — En Safari iOS `100vh` NO es la altura visible.
   El intento de arreglo original (`--vh` por JS) **nunca se aplicaba en el CSS**.
   → Ahora se usa `100dvh` con fallbacks (`-webkit-fill-available`).
2. **Botones tapados por la barra de inicio del iPhone** — faltaba
   `viewport-fit=cover` y la clase `pb-safe` no existe en Tailwind.
   → Ahora hay padding real con `env(safe-area-inset-bottom)`.
3. **Parte superior de la lámina cortada en iPhones cortos** — `flex items-center`
   forzaba el centrado vertical. → En móvil ahora es `items-start` (centrado solo
   desde `sm:` hacia arriba).
4. **`slate-850` no existe en Tailwind** (bordes invisibles) → reemplazado por `slate-800`.
5. Se agregó `inputmode="decimal"` y reset de scroll al cambiar de lámina.

> **La clave para iOS es servirlo como URL** (Safari real), no como archivo `.html`
> adjunto (que iOS abre en el navegador interno de WhatsApp, más frágil).

## Probar localmente

```bash
cd docs && python3 -m http.server 8080
# abrir http://localhost:8080
```

## Publicar / sincronizar al VPS

Editar las variables al inicio de `deploy.sh` (host, ruta destino) y ejecutar:

```bash
./deploy.sh
```

Esto copia `docs/` al VPS por `rsync` sobre SSH. Allí basta con servir esa
carpeta con nginx / caddy / `python3 -m http.server` para tener la URL pública.
