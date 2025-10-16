#!/bin/bash
# Script para ejecutar las pruebas dentro del entorno virtual
# Este script activa el entorno virtual y ejecuta los tests de login

set -e  # Salir si hay algún error

VENV_DIR="venv"

echo "======================================"
echo "Ejecutando Pruebas de Login"
echo "======================================"

# Verificar que existe el entorno virtual
if [ ! -d "$VENV_DIR" ]; then
    echo "ERROR: El entorno virtual no existe en '$VENV_DIR'"
    echo "Por favor ejecute primero: ./setup_venv.sh"
    exit 1
fi

# Activar el entorno virtual
echo "Activando entorno virtual..."
source "$VENV_DIR/bin/activate"

# Verificar que las dependencias están instaladas
echo ""
echo "Verificando dependencias..."
if ! python3 -c "import selenium" 2>/dev/null; then
    echo "ERROR: Selenium no está instalado en el entorno virtual"
    echo "Por favor ejecute: ./setup_venv.sh"
    exit 1
fi

echo "✓ Dependencias verificadas"

# Ejecutar las pruebas
echo ""
echo "======================================"
echo "EJECUTANDO TESTS"
echo "======================================"

# Test con credenciales correctas
echo ""
echo "1. Test con credenciales correctas..."
python3 test_login.py --mode correct

# Test con credenciales incorrectas
echo ""
echo "2. Test con credenciales incorrectas..."
python3 test_login.py --mode incorrect

echo ""
echo "======================================"
echo "✓ Todas las pruebas completadas"
echo "======================================"

# Desactivar el entorno virtual
deactivate
