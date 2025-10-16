#!/bin/bash
# Script para crear y configurar el entorno virtual
# Este script crea un entorno virtual de Python e instala todas las dependencias necesarias

set -e  # Salir si hay algún error

VENV_DIR="venv"

echo "======================================"
echo "Configuración del Entorno Virtual"
echo "======================================"

# Verificar que Python3 está instalado
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 no está instalado."
    echo "Por favor instale Python 3 antes de continuar."
    exit 1
fi

echo "✓ Python3 encontrado: $(python3 --version)"

# Crear el entorno virtual si no existe
if [ ! -d "$VENV_DIR" ]; then
    echo ""
    echo "Creando entorno virtual en '$VENV_DIR'..."
    python3 -m venv "$VENV_DIR"
    echo "✓ Entorno virtual creado exitosamente"
else
    echo ""
    echo "✓ Entorno virtual ya existe en '$VENV_DIR'"
fi

# Activar el entorno virtual
echo ""
echo "Activando entorno virtual..."
source "$VENV_DIR/bin/activate"

# Actualizar pip
echo ""
echo "Actualizando pip..."
pip install --upgrade pip

# Instalar dependencias desde requirements.txt
echo ""
echo "Instalando dependencias desde requirements.txt..."
pip install -r requirements.txt

# Mostrar paquetes instalados
echo ""
echo "======================================"
echo "Paquetes instalados:"
echo "======================================"
pip list

echo ""
echo "======================================"
echo "✓ Configuración completada exitosamente"
echo "======================================"
echo ""
echo "Para activar el entorno virtual manualmente, ejecuta:"
echo "  source $VENV_DIR/bin/activate"
echo ""
echo "Para desactivar el entorno virtual, ejecuta:"
echo "  deactivate"
echo ""
