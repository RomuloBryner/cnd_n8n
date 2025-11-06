#!/bin/bash

# Script para iniciar n8n con validaciones

echo "=================================="
echo "🚀 Iniciando n8n CND WhatsApp Bot"
echo "=================================="

# Verificar que existe el archivo .env
if [ ! -f .env ]; then
    echo "⚠️  Archivo .env no encontrado"
    echo "📝 Creando .env desde env.example..."
    cp env.example .env
    echo "✅ Archivo .env creado"
    echo ""
    echo "🔧 Por favor, edita el archivo .env con tus credenciales antes de continuar"
    echo "   Especialmente: WA_API_KEY"
    echo ""
    read -p "Presiona Enter cuando hayas configurado el archivo .env..."
fi

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo"
    echo "   Por favor, inicia Docker Desktop y vuelve a intentar"
    exit 1
fi

echo "✅ Docker está corriendo"
echo ""

# Verificar si el contenedor ya está corriendo
if [ "$(docker ps -q -f name=cnd_n8n)" ]; then
    echo "⚠️  El contenedor n8n ya está corriendo"
    echo ""
    read -p "¿Quieres reiniciarlo? (s/n): " respuesta
    if [ "$respuesta" = "s" ] || [ "$respuesta" = "S" ]; then
        echo "🔄 Reiniciando n8n..."
        docker-compose restart
    fi
else
    echo "🚀 Iniciando n8n..."
    docker-compose up -d
fi

echo ""
echo "=================================="
echo "✅ n8n está corriendo!"
echo "=================================="
echo ""
echo "📍 Accede a n8n en: http://localhost:5678"
echo "👤 Usuario: $(grep N8N_USER .env | cut -d '=' -f2)"
echo "🔑 Contraseña: (ver archivo .env)"
echo ""
echo "📋 Comandos útiles:"
echo "   docker-compose logs -f n8n    # Ver logs"
echo "   docker-compose stop            # Detener n8n"
echo "   docker-compose down            # Detener y eliminar"
echo ""
echo "🔗 Webhook URL para WhatsApp:"
echo "   http://localhost:5678/webhook/whatsapp"
echo "   (Usa ngrok si estás en desarrollo local)"
echo ""

