@echo off
REM Script para iniciar n8n en Windows

echo ==================================
echo Iniciando n8n CND WhatsApp Bot
echo ==================================
echo.

REM Verificar que existe el archivo .env
if not exist .env (
    echo Archivo .env no encontrado
    echo Creando .env desde env.example...
    copy env.example .env
    echo Archivo .env creado
    echo.
    echo Por favor, edita el archivo .env con tus credenciales
    echo Especialmente: WA_API_KEY
    echo.
    pause
)

REM Verificar que Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo Docker no esta corriendo
    echo Por favor, inicia Docker Desktop y vuelve a intentar
    pause
    exit /b 1
)

echo Docker esta corriendo
echo.

REM Iniciar n8n
echo Iniciando n8n...
docker-compose up -d

echo.
echo ==================================
echo n8n esta corriendo!
echo ==================================
echo.
echo Accede a n8n en: http://localhost:5678
echo.
echo Comandos utiles:
echo   docker-compose logs -f n8n    - Ver logs
echo   docker-compose stop            - Detener n8n
echo   docker-compose down            - Detener y eliminar
echo.
echo Webhook URL para WhatsApp:
echo   http://localhost:5678/webhook/whatsapp
echo   (Usa ngrok si estas en desarrollo local)
echo.
pause

