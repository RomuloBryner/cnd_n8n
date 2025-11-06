# 📂 Estructura del Proyecto n8n

```
n8n/
│
├── 📄 CND Whatsapp API.json        # Workflow principal de WhatsApp
│   └── Flujo completo del chatbot con todos los casos de uso
│
├── 🐳 docker-compose.yml            # Configuración de Docker
│   ├── Imagen: n8nio/n8n:latest
│   ├── Puerto: 5678
│   └── Volúmenes persistentes
│
├── ⚙️  env.example                  # Ejemplo de variables de entorno
│   └── Plantilla para crear .env
│
├── 🔒 .env                          # Variables de entorno (NO VERSIONADO)
│   ├── Credenciales de n8n
│   ├── Access Token de WhatsApp
│   └── Configuración de Strapi
│
├── 🚀 start.bat                     # Script de inicio para Windows
│   └── Verifica requisitos e inicia Docker
│
├── 🚀 start.sh                      # Script de inicio para Linux/Mac
│   └── Verifica requisitos e inicia Docker
│
├── 📚 README.md                     # Documentación principal
│   ├── Comandos Docker
│   ├── Configuración de webhook
│   └── Troubleshooting
│
├── 📘 SETUP.md                      # Guía detallada de configuración
│   ├── Configuración paso a paso
│   ├── Webhooks de WhatsApp
│   └── Ngrok para desarrollo
│
├── ⚡ QUICK_START.md                # Inicio rápido (3 pasos)
│   └── Para empezar rápidamente
│
├── 📋 ESTRUCTURA.md                 # Este archivo
│   └── Explicación de la estructura
│
├── 📁 workflows/                    # Backups automáticos de workflows
│   └── .gitkeep
│
└── 🙈 .gitignore                    # Archivos ignorados por git
    ├── .env (credenciales)
    ├── n8n_data/ (datos de n8n)
    └── logs
```

## 🔄 Flujo de Trabajo

```
┌─────────────────────────────────────────────────────────────────┐
│                         WhatsApp User                           │
│                              ↓                                   │
│                    Envía mensaje por WhatsApp                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Meta WhatsApp API                            │
│                              ↓                                   │
│              POST /webhook/whatsapp (n8n)                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      n8n (Docker)                               │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  1. Webhook recibe mensaje                             │    │
│  │  2. Lib: helpers - Parsea datos                        │    │
│  │  3. Verifica horario y sesión                          │    │
│  │  4. Busca cliente en Strapi                            │    │
│  │  5. Procesa flujo según postback                       │    │
│  │  6. Responde vía WhatsApp API                          │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Strapi Backend                               │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  - Customers / Hotel Members                           │    │
│  │  - Tickets / Ticket Temporals                          │    │
│  │  - Messages                                             │    │
│  │  - CSAT / CSAT Temporals                               │    │
│  │  - Zones / Users                                        │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Meta WhatsApp API                            │
│                              ↓                                   │
│                  Envía respuesta al usuario                     │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                         WhatsApp User                           │
│                    Recibe respuesta del bot                     │
└─────────────────────────────────────────────────────────────────┘
```

## 🔧 Componentes Clave

### Docker Compose
- **Servicio**: n8n
- **Imagen**: n8nio/n8n:latest
- **Puerto**: 5678
- **Persistencia**: Volumen `n8n_data`
- **Red**: `n8n_network`

### Variables de Entorno
| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `N8N_USER` | Usuario de login | admin |
| `N8N_PASSWORD` | Contraseña de login | admin123 |
| `WEBHOOK_URL` | URL pública de n8n | http://localhost:5678/ |
| `WA_API_KEY` | Access Token de WhatsApp | (requerido) |
| `WA_PHONE_NUMBER_ID` | ID del número de WhatsApp | 848478885021265 |
| `STRAPI_URL` | URL del backend Strapi | http://host.docker.internal:1337 |
| `STRAPI_TOKEN` | Token de autenticación | (ver env.example) |

### Volúmenes Docker
- `n8n_data`: Almacena base de datos y configuración de n8n
- `./workflows`: Backup de workflows (montado)
- `./CND Whatsapp API.json`: Workflow para auto-importar (read-only)

## 📊 Endpoints

- **n8n UI**: http://localhost:5678
- **Health Check**: http://localhost:5678/healthz
- **Webhook WhatsApp**: http://localhost:5678/webhook/whatsapp
- **Strapi Backend**: http://localhost:1337

## 🔐 Seguridad

### Archivos NO Versionados (.gitignore)
- ✅ `.env` - Credenciales sensibles
- ✅ `n8n_data/` - Base de datos local
- ✅ `*.log` - Archivos de log

### Archivos Versionados
- ✅ `env.example` - Plantilla de configuración
- ✅ `docker-compose.yml` - Configuración de Docker
- ✅ `CND Whatsapp API.json` - Workflow del bot
- ✅ Documentación y scripts

## 📝 Comandos Rápidos

```bash
# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f n8n

# Detener
docker-compose down

# Reiniciar
docker-compose restart

# Actualizar n8n
docker-compose pull && docker-compose up -d

# Backup
docker-compose exec n8n n8n export:workflow --all --output=/home/node/.n8n/workflows/
```

## 🌐 URLs Importantes

- 🔗 Repositorio: https://github.com/RomuloBryner/cnd_n8n
- 📱 WhatsApp: +1 (829) 762-1710
- 🏢 Meta Developer Console: https://developers.facebook.com/apps/
- 📚 Documentación n8n: https://docs.n8n.io/

