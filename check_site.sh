#!/bin/bash

# Script simple para verificar acceso al sitio de login
# Este script solo verifica que el sitio esté accesible
# Para pruebas completas de login, usar test_login.py

SITE_URL="https://clasesprofesores.net/login"

echo "======================================"
echo "Verificación de acceso al sitio"
echo "URL: $SITE_URL"
echo "======================================"

# Verificar conectividad básica
echo ""
echo "1. Verificando conectividad HTTP..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL" --max-time 10)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✓ Sitio accesible (HTTP $HTTP_CODE)"
elif [ "$HTTP_CODE" -eq 301 ] || [ "$HTTP_CODE" -eq 302 ]; then
    echo "✓ Sitio responde con redirección (HTTP $HTTP_CODE)"
elif [ "$HTTP_CODE" -eq 000 ]; then
    echo "✗ No se pudo conectar al sitio (timeout o error de red)"
    exit 1
else
    echo "⚠ Sitio responde con código inesperado: HTTP $HTTP_CODE"
fi

# Verificar contenido del sitio
echo ""
echo "2. Verificando contenido de la página..."
CONTENT=$(curl -s "$SITE_URL" --max-time 10)

if echo "$CONTENT" | grep -qi "login\|password\|usuario\|contraseña"; then
    echo "✓ Página contiene elementos de login"
else
    echo "⚠ No se detectaron elementos típicos de login en la página"
fi

# Verificar certificado SSL
echo ""
echo "3. Verificando certificado SSL..."
SSL_CHECK=$(curl -s -I "$SITE_URL" 2>&1 | grep -i "SSL certificate problem" || echo "OK")

if [ "$SSL_CHECK" = "OK" ]; then
    echo "✓ Certificado SSL válido"
else
    echo "⚠ Posible problema con certificado SSL"
fi

echo ""
echo "======================================"
echo "Verificación completada"
echo "======================================"
echo ""
echo "NOTA: Esta es solo una verificación básica."
echo "Para pruebas completas de login use: python3 test_login.py"
