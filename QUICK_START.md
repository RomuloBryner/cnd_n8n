# 🚀 Inicio Rápido - n8n CND WhatsApp Bot

## ⚡ Configuración en 3 pasos

### 1️⃣ Crear archivo .env

```bash
# Copiar el archivo de ejemplo
copy env.example .env
```

O crea manualmente el archivo `.env` con este contenido:

```env
# Configuración de n8n
N8N_USER=admin
N8N_PASSWORD=admin123

# URL del webhook
WEBHOOK_URL=http://localhost:5678/

# WhatsApp Business API
WA_API_KEY=EAALfFZAYSb7sBP4iWopkDfxZB7z9T4JhbYZBqVTGiJkfthApuHWAZAoAoy75QEg816ZCZBZAOiCPjzJcaaVbhZBG4LNe0giSKRsZCHarDg7topCOpuhRjUQRkbbhjLNFLMNtFsr8RgRP75sQGSfEzWydKq9NxZC9JH4w3bRFKRrLt6j1AsiSTYJCyfp15ILlM6Y9m8dQZDZD
WA_PHONE_NUMBER_ID=848478885021265

# Strapi Backend
STRAPI_URL=http://host.docker.internal:1337
STRAPI_TOKEN=7853e2cdbbee30cf852855174eb9e7714cee7af46db90dcfc5cac9e4ae3b815f73f3fa93809a511329bcb2e61b36f3cb595f4d960f34ba9c707a3cabee8fb5cf171d4d90ca2b789db261bfac703e5d6001fba1cfc23c3e80bf26d550a5385de9564513cee4e6f4c38582ab6968aa3e1a46135e3476f514f6aa63b89b4c7fdb11
```

### 2️⃣ Iniciar n8n

```bash
# Ejecutar el script de inicio
start.bat

# O manualmente:
docker-compose up -d
```

### 3️⃣ Acceder a n8n

1. Abre: http://localhost:5678
2. Login con: **admin** / **admin123**
3. El workflow ya está importado y listo para usar

## ✅ Checklist

- [ ] Docker Desktop está corriendo
- [ ] Archivo `.env` creado y configurado
- [ ] Backend Strapi corriendo en `localhost:1337`
- [ ] Ejecutado `docker-compose up -d`
- [ ] Accedido a http://localhost:5678
- [ ] Workflow "CND Whatsapp API" visible y activo

## 🔗 Configurar Webhook de WhatsApp

Para recibir mensajes de WhatsApp, necesitas exponer tu webhook públicamente.

### Desarrollo Local (ngrok)

```bash
# 1. Descargar ngrok: https://ngrok.com/download

# 2. Iniciar ngrok
ngrok http 5678

# 3. Copiar la URL HTTPS (ej: https://abc123.ngrok.io)

# 4. Configurar en Meta Developer Console:
#    Callback URL: https://abc123.ngrok.io/webhook/whatsapp
#    Verify Token: b87f9f59-6741-4f80-ab3a-7ec48b5b2e87
```

### Producción (Servidor público)

Si tienes un servidor con dominio:

```bash
# Configurar en Meta Developer Console:
# Callback URL: https://tu-dominio.com/webhook/whatsapp
# Verify Token: b87f9f59-6741-4f80-ab3a-7ec48b5b2e87
```

## 📱 Probar el Bot

1. Envía un mensaje al número de WhatsApp Business configurado
2. Debes recibir respuesta del bot
3. Revisa las ejecuciones en n8n: **Executions** (panel izquierdo)

## 🆘 Problemas Comunes

### El contenedor no inicia

```bash
# Ver logs
docker-compose logs n8n

# Verificar si el puerto está en uso
netstat -ano | findstr :5678
```

### No recibe mensajes de WhatsApp

1. Verifica que el webhook esté configurado en Meta
2. Verifica que ngrok esté corriendo (si lo usas)
3. Activa el workflow en n8n (toggle "Active")

### Error de conexión con Strapi

```bash
# Verificar que Strapi está corriendo
curl http://localhost:1337/admin

# Si usas Docker en Windows, asegúrate de usar:
# STRAPI_URL=http://host.docker.internal:1337
```

## 📞 Información

- **Número WhatsApp**: +1 (829) 762-1710
- **Phone Number ID**: 848478885021265
- **Webhook Path**: `/webhook/whatsapp`
- **n8n UI**: http://localhost:5678

---

Para más detalles, consulta:
- `README.md` - Documentación completa
- `SETUP.md` - Guía detallada de configuración

