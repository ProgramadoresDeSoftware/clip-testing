# Guía de Uso del Entorno Virtual

Este documento explica cómo usar el entorno virtual de Python para ejecutar las pruebas de login.

## ¿Qué es un Entorno Virtual?

Un entorno virtual (virtual environment o venv) es un directorio aislado que contiene una instalación de Python y sus paquetes. Permite:

- **Aislar dependencias**: Los paquetes instalados no interfieren con otros proyectos
- **Reproducibilidad**: El mismo entorno puede recrearse en cualquier máquina
- **Limpieza**: Se puede eliminar completamente sin afectar el sistema

## Configuración Inicial

### 1. Crear el Entorno Virtual

Ejecuta el script de configuración para crear el entorno virtual e instalar todas las dependencias:

```bash
./setup_venv.sh
```

Este script:
- Verifica que Python 3 esté instalado
- Crea un directorio `venv/` con el entorno virtual
- Instala todas las dependencias desde `requirements.txt`
- Muestra la lista de paquetes instalados

## Uso del Entorno Virtual

### Opción 1: Ejecución Automática (Recomendado)

El script `run_tests.sh` activa automáticamente el entorno virtual, ejecuta las pruebas y lo desactiva:

```bash
./run_tests.sh
```

### Opción 2: Ejecución Manual

Si prefieres tener más control, puedes activar el entorno virtual manualmente:

```bash
# 1. Activar el entorno virtual
source venv/bin/activate

# 2. Tu prompt cambiará para mostrar (venv) al inicio
# Ahora puedes ejecutar comandos de Python:

# Ejecutar prueba con credenciales correctas
python3 test_login.py --mode correct

# Ejecutar prueba con credenciales incorrectas
python3 test_login.py --mode incorrect

# Ver paquetes instalados
pip list

# 3. Desactivar el entorno virtual cuando termines
deactivate
```

## Gestión del Entorno Virtual

### Verificar el Estado

Para verificar si el entorno virtual está activo, observa tu prompt:
- Con entorno activo: `(venv) user@host:~$`
- Sin entorno activo: `user@host:~$`

También puedes verificar qué Python estás usando:

```bash
which python3
# Con venv activo: /path/to/project/venv/bin/python3
# Sin venv: /usr/bin/python3
```

### Actualizar Dependencias

Si se actualizan las dependencias en `requirements.txt`:

```bash
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
```

O simplemente vuelve a ejecutar el script de configuración:

```bash
./setup_venv.sh
```

### Recrear el Entorno Virtual

Si necesitas recrear el entorno virtual desde cero:

```bash
# 1. Eliminar el directorio del entorno virtual
rm -rf venv/

# 2. Crear nuevamente
./setup_venv.sh
```

## Integración con Jenkins

El pipeline de Jenkins está configurado para usar el entorno virtual automáticamente:

1. La etapa "Setup" ejecuta `./setup_venv.sh` para crear el entorno
2. Las etapas de prueba activan el entorno con `source venv/bin/activate`
3. Las pruebas se ejecutan dentro del entorno virtual

No se requiere configuración adicional en Jenkins.

## Solución de Problemas

### Error: "python3: command not found"

Solución: Instala Python 3 en tu sistema:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3 python3-venv python3-pip

# macOS (con Homebrew)
brew install python3
```

### Error: "No module named 'venv'"

Solución: Instala el módulo venv:

```bash
# Ubuntu/Debian
sudo apt-get install python3-venv
```

### El entorno virtual no se activa

Verifica que estás usando `source` (no `sh` ni `bash`):

```bash
# Correcto
source venv/bin/activate

# Incorrecto
sh venv/bin/activate
bash venv/bin/activate
```

### Paquetes no disponibles después de instalar

Asegúrate de que el entorno virtual está activado antes de instalar paquetes:

```bash
source venv/bin/activate
pip install -r requirements.txt
```

## Estructura de Archivos

```
clip-testing/
├── venv/                    # Entorno virtual (ignorado por git)
│   ├── bin/                 # Ejecutables (python, pip, etc.)
│   ├── lib/                 # Paquetes instalados
│   └── pyvenv.cfg          # Configuración del entorno
├── setup_venv.sh           # Script de configuración
├── run_tests.sh            # Script para ejecutar pruebas
├── requirements.txt        # Lista de dependencias
└── test_login.py          # Script de pruebas
```

## Notas Importantes

- El directorio `venv/` está en `.gitignore` y **no debe** subirse al repositorio
- Cada desarrollador debe crear su propio entorno virtual local
- Las dependencias se especifican en `requirements.txt` para garantizar consistencia
- El entorno virtual debe recrearse si cambias de versión de Python

## Recursos Adicionales

- [Documentación oficial de venv](https://docs.python.org/3/library/venv.html)
- [Guía de Python sobre entornos virtuales](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/)
