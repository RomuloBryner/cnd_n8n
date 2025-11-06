# n8n Dockerizado - CND WhatsApp Bot

Este directorio contiene la configuración de n8n dockerizado para el chatbot de WhatsApp de CND.

## 🚀 Inicio Rápido

### 1. Configurar variables de entorno

```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar el archivo .env con tus credenciales
# Especialmente WA_API_KEY con tu Access Token de WhatsApp
```

### 2. Iniciar n8n

```bash
# Iniciar el contenedor
docker-compose up -d

# Ver los logs
docker-compose logs -f n8n

# Detener el contenedor
docker-compose down

# Detener y eliminar volúmenes (CUIDADO: elimina todos los datos)
docker-compose down -v
```

### 3. Acceder a n8n

1. Abre tu navegador en: http://localhost:5678
2. Inicia sesión con:
   - **Usuario**: admin (o el valor de `N8N_USER` en `.env`)
   - **Contraseña**: admin123 (o el valor de `N8N_PASSWORD` en `.env`)

### 4. Importar el workflow

El workflow `CND Whatsapp API.json` se importa automáticamente al iniciar el contenedor.

**Alternativa manual**:
1. En n8n, ve a **Workflows** → **Import from File**
2. Selecciona el archivo `CND Whatsapp API.json`
3. Haz clic en **Import**

## 📋 Configuración del Webhook

### Configurar WhatsApp Webhook en Meta

1. Ve a [Meta for Developers](https://developers.facebook.com/apps/)
2. Selecciona tu aplicación de WhatsApp Business
3. Ve a **WhatsApp** → **Configuration**
4. En **Webhook**, haz clic en **Edit**
5. Configura:
   - **Callback URL**: `http://tu-servidor:5678/webhook/whatsapp` (o usa ngrok para desarrollo)
   - **Verify Token**: `b87f9f59-6741-4f80-ab3a-7ec48b5b2e87` (o el que esté en tu workflow)
6. Suscríbete a los eventos: `messages`

### Usar ngrok para desarrollo local

Si estás en desarrollo local y necesitas exponer tu webhook:

```bash
# Instalar ngrok: https://ngrok.com/download

# Exponer el puerto 5678
ngrok http 5678

# Copiar la URL HTTPS que te da ngrok (ej: https://abc123.ngrok.io)
# Usarla como WEBHOOK_URL en tu .env
```

Luego actualiza tu `.env`:
```bash
WEBHOOK_URL=https://abc123.ngrok.io/
```

Y reinicia n8n:
```bash
docker-compose restart
```

## 🔧 Estructura del Proyecto

```
n8n/
├── docker-compose.yml          # Configuración de Docker
├── .env                         # Variables de entorno (no versionado)
├── .env.example                 # Ejemplo de variables de entorno
├── .gitignore                   # Archivos a ignorar en git
├── README.md                    # Esta documentación
├── CND Whatsapp API.json        # Workflow principal de WhatsApp
└── workflows/                   # Backups de workflows (creado automáticamente)
```

## 🔐 Variables de Entorno

### Obligatorias

- `WA_API_KEY`: Access Token de WhatsApp Business API
- `WA_PHONE_NUMBER_ID`: ID del número de teléfono de WhatsApp

### Opcionales

- `N8N_USER`: Usuario para login (default: admin)
- `N8N_PASSWORD`: Contraseña para login (default: admin123)
- `WEBHOOK_URL`: URL pública de n8n (default: http://localhost:5678/)
- `STRAPI_URL`: URL de tu backend Strapi (default: http://host.docker.internal:1337)
- `STRAPI_TOKEN`: Token de autenticación de Strapi

## 📦 Características

- ✅ Base de datos SQLite persistente
- ✅ Auto-restart del contenedor
- ✅ Workflows importados automáticamente
- ✅ Variables de entorno configurables
- ✅ Logs accesibles con `docker-compose logs`
- ✅ Backup automático de workflows
- ✅ Timezone configurado para República Dominicana

## 🛠️ Comandos Útiles

### Ver logs en tiempo real
```bash
docker-compose logs -f n8n
```

### Reiniciar n8n
```bash
docker-compose restart
```

### Acceder al contenedor
```bash
docker-compose exec n8n sh
```

### Ver workflows guardados
```bash
ls -la workflows/
```

### Backup manual de workflows
```bash
# Los workflows se guardan automáticamente en ./workflows/
# Puedes hacer un backup copiando toda la carpeta:
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz workflows/
```

### Restaurar desde backup
```bash
# Extraer el backup
tar -xzf n8n-backup-20250101.tar.gz

# Reiniciar n8n para cargar los workflows
docker-compose restart
```

## 🔄 Actualizar n8n

```bash
# Detener el contenedor
docker-compose down

# Descargar la última imagen
docker-compose pull

# Iniciar con la nueva versión
docker-compose up -d
```

## 🐛 Troubleshooting

### El webhook no recibe mensajes

1. Verifica que el webhook esté correctamente configurado en Meta
2. Verifica que la URL del webhook sea accesible públicamente
3. Revisa los logs: `docker-compose logs -f n8n`

### El contenedor no inicia

```bash
# Ver los logs
docker-compose logs n8n

# Verificar si hay conflictos de puerto
netstat -ano | findstr :5678

# Cambiar el puerto en docker-compose.yml si es necesario
```

### No puede conectar con Strapi

1. Verifica que Strapi esté corriendo: `curl http://localhost:1337/admin`
2. Verifica la URL en `.env`: `STRAPI_URL=http://host.docker.internal:1337`
3. En Windows, asegúrate de que Docker Desktop esté configurado para compartir archivos

### Problemas con WhatsApp API

1. Verifica que `WA_API_KEY` esté correctamente configurada
2. Verifica que el token no haya expirado
3. Revisa los logs del workflow en n8n

## 📚 Recursos

- [Documentación de n8n](https://docs.n8n.io/)
- [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp)
- [Docker Compose](https://docs.docker.com/compose/)

## 🆘 Soporte

Si tienes problemas, revisa:
1. Los logs de n8n: `docker-compose logs -f n8n`
2. Los logs de Strapi en el backend
3. La configuración del webhook en Meta Developer Console

