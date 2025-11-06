# Guía de Configuración de n8n para CND WhatsApp Bot

## 📋 Requisitos Previos

- Docker Desktop instalado y corriendo
- Puerto 5678 disponible
- Backend de Strapi corriendo en `localhost:1337`
- Credenciales de WhatsApp Business API

## 🔧 Configuración Inicial

### Paso 1: Configurar Variables de Entorno

1. Copia el archivo de ejemplo:
   ```bash
   cp env.example .env
   ```

2. Edita el archivo `.env` y configura:
   ```bash
   # Cambia estos valores
   N8N_USER=tu_usuario
   N8N_PASSWORD=tu_password_seguro
   
   # IMPORTANTE: Configura tu Access Token de WhatsApp
   WA_API_KEY=tu_access_token_de_whatsapp
   ```

### Paso 2: Iniciar n8n

**En Windows**:
```bash
start.bat
```

**En Linux/Mac**:
```bash
chmod +x start.sh
./start.sh
```

**Manual**:
```bash
docker-compose up -d
```

### Paso 3: Acceder a n8n

1. Abre tu navegador en: http://localhost:5678
2. Inicia sesión con las credenciales configuradas en `.env`

### Paso 4: Activar el Workflow

1. En n8n, ve a **Workflows**
2. Busca el workflow "CND Whatsapp API"
3. Haz clic en **Active** (toggle en la esquina superior derecha)
4. El workflow ahora estará escuchando en el webhook

## 🌐 Configurar Webhook de WhatsApp

### Opción A: Producción (con servidor público)

Si tienes un servidor con IP pública o dominio:

1. Configura `WEBHOOK_URL` en `.env`:
   ```bash
   WEBHOOK_URL=https://tu-dominio.com/
   ```

2. En Meta Developer Console:
   - **Callback URL**: `https://tu-dominio.com/webhook/whatsapp`
   - **Verify Token**: `b87f9f59-6741-4f80-ab3a-7ec48b5b2e87`

### Opción B: Desarrollo Local (con ngrok)

Para desarrollo local, usa ngrok para exponer tu webhook:

1. Instala ngrok: https://ngrok.com/download

2. Inicia ngrok:
   ```bash
   ngrok http 5678
   ```

3. Ngrok te dará una URL HTTPS (ej: `https://abc123.ngrok.io`)

4. Actualiza tu `.env`:
   ```bash
   WEBHOOK_URL=https://abc123.ngrok.io/
   ```

5. Reinicia n8n:
   ```bash
   docker-compose restart
   ```

6. Configura en Meta Developer Console:
   - **Callback URL**: `https://abc123.ngrok.io/webhook/whatsapp`
   - **Verify Token**: `b87f9f59-6741-4f80-ab3a-7ec48b5b2e87`

## 🔑 Obtener Credenciales de WhatsApp

### Access Token (WA_API_KEY)

1. Ve a [Meta for Developers](https://developers.facebook.com/apps/)
2. Selecciona tu aplicación
3. Ve a **WhatsApp** → **API Setup**
4. Copia el **Temporary access token** (válido por 24 horas)
5. O genera un **Permanent access token** en **Settings** → **System Users**

### Phone Number ID (WA_PHONE_NUMBER_ID)

1. En la misma página de API Setup
2. Busca la sección **From**
3. Copia el **Phone number ID** (número largo)

## 🧪 Probar el Webhook

### 1. Verificar que n8n está corriendo

```bash
curl http://localhost:5678/healthz
```

### 2. Probar el webhook manualmente

```bash
curl -X POST http://localhost:5678/webhook/whatsapp \
  -H "Content-Type: application/json" \
  -d '{
    "entry": [{
      "changes": [{
        "value": {
          "messages": [{
            "from": "18297621710",
            "type": "text",
            "text": { "body": "Hola" }
          }],
          "contacts": [{
            "wa_id": "18297621710",
            "profile": { "name": "Test User" }
          }]
        }
      }]
    }]
  }'
```

### 3. Verificar los logs

```bash
docker-compose logs -f n8n
```

## 📊 Monitoreo

### Ver execuciones del workflow

1. En n8n, ve a **Executions** en el panel izquierdo
2. Aquí verás todas las ejecuciones del workflow
3. Haz clic en cualquiera para ver los detalles

### Ver logs del contenedor

```bash
# Logs en tiempo real
docker-compose logs -f n8n

# Últimas 100 líneas
docker-compose logs --tail=100 n8n

# Logs desde una fecha específica
docker-compose logs --since="2025-01-01T00:00:00" n8n
```

## 🔄 Backup y Restauración

### Hacer Backup

Los workflows se guardan automáticamente en `./workflows/`. Para hacer un backup completo:

```bash
# Backup manual
docker-compose exec n8n n8n export:workflow --all --output=/home/node/.n8n/workflows/

# O desde Windows/Linux
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz workflows/ n8n_data/
```

### Restaurar Backup

```bash
# Restaurar workflows
tar -xzf n8n-backup-20250101.tar.gz

# Reiniciar n8n
docker-compose restart
```

## 🚨 Solución de Problemas

### Error: "Port 5678 already in use"

```bash
# Ver qué proceso está usando el puerto
netstat -ano | findstr :5678

# Cambiar el puerto en docker-compose.yml
# Buscar: "5678:5678" y cambiar a "5679:5678"
```

### Error: "Cannot connect to Strapi"

Verifica que:
1. Strapi está corriendo: `curl http://localhost:1337/admin`
2. La URL en `.env` es correcta: `STRAPI_URL=http://host.docker.internal:1337`
3. El token de Strapi es válido

### Error: "WhatsApp API returns 401"

1. Verifica que `WA_API_KEY` esté correctamente configurada
2. Genera un nuevo Access Token si expiró
3. Reinicia n8n: `docker-compose restart`

### El workflow no se importa automáticamente

Importa manualmente:
1. En n8n, ve a **Settings** → **Import**
2. Selecciona `CND Whatsapp API.json`
3. Haz clic en **Import**

## 🔐 Seguridad

### En Producción

1. **Cambia las credenciales por defecto**:
   ```bash
   N8N_USER=tu_usuario_seguro
   N8N_PASSWORD=tu_password_muy_seguro
   ```

2. **Usa HTTPS**:
   - Configura un reverse proxy (nginx)
   - Usa un certificado SSL (Let's Encrypt)

3. **Protege el archivo `.env`**:
   - Nunca lo subas a git
   - Usa variables de entorno del sistema en producción

4. **Limita el acceso**:
   - Usa firewall para limitar acceso al puerto 5678
   - Considera usar VPN

## 📝 Mantenimiento

### Limpiar logs antiguos

```bash
# Rotar logs de Docker
docker-compose logs > n8n-logs-$(date +%Y%m%d).log
docker-compose restart
```

### Actualizar workflow

1. Edita el workflow en n8n
2. Exporta el workflow: **Workflow** → **Download**
3. Reemplaza `CND Whatsapp API.json` con el nuevo archivo
4. Commit y push a git

## 📞 Información de Contacto

- **Número de WhatsApp**: +1 (829) 762-1710
- **Phone Number ID**: 848478885021265
- **Webhook Path**: `/webhook/whatsapp`

