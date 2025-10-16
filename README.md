# Pipeline de Prueba de Login - clasesprofesores.net

Este proyecto contiene un pipeline de Jenkins para probar el acceso al login del sitio web clasesprofesores.net/login.

## Descripción

El pipeline automatiza las pruebas de login con dos escenarios:
1. **Credenciales correctas**: Verifica que el formulario de login acepta credenciales válidas
2. **Credenciales incorrectas**: Verifica que el formulario de login rechaza credenciales inválidas

## Entorno Virtual

Este proyecto utiliza un entorno virtual de Python para aislar las dependencias y garantizar que las pruebas se ejecuten en un entorno controlado y reproducible. Esto evita conflictos con otras instalaciones de Python en el sistema.

### Ventajas del entorno virtual:
- **Aislamiento**: Las dependencias no interfieren con otros proyectos
- **Reproducibilidad**: El entorno es consistente entre diferentes máquinas
- **Limpieza**: Fácil de eliminar y recrear sin afectar el sistema

## Archivos del Proyecto

- `Jenkinsfile`: Definición del pipeline de Jenkins
- `test_login.py`: Script de prueba en Python usando Selenium
- `requirements.txt`: Dependencias de Python necesarias
- `JENKINS_SETUP.md`: Instrucciones detalladas de configuración de Jenkins
- `DIAGNOSTICO_JENKINS.md`: Diagnóstico de problemas comunes y salida esperada

## Requisitos

### Para ejecutar localmente:
- Python 3.6+
- Chrome/Chromium browser
- ChromeDriver

### Para ejecutar en Jenkins:
- Jenkins con soporte para pipelines
- Python 3 (versión 3.7 o superior) instalado en el agente de Jenkins
- pip3 instalado en el agente de Jenkins
- Módulo venv de Python (normalmente incluido con Python 3)
- Google Chrome instalado en el agente de Jenkins
- ChromeDriver instalado en el agente de Jenkins (compatible con la versión de Chrome)

**Nota**: El pipeline creará automáticamente un entorno virtual e instalará las dependencias de Python (selenium, requests) durante la etapa de Setup. Ver `JENKINS_SETUP.md` para instrucciones detalladas de configuración.

## Uso

### Ejecutar localmente

#### Método recomendado: Usar entorno virtual (automático)

1. Configurar entorno virtual e instalar dependencias:
```bash
./setup_venv.sh
```

2. Ejecutar todas las pruebas:
```bash
./run_tests.sh
```

#### Método alternativo: Ejecución manual con entorno virtual

1. Configurar entorno virtual:
```bash
./setup_venv.sh
```

2. Activar el entorno virtual:
```bash
source venv/bin/activate
```

3. Ejecutar prueba con credenciales correctas:
```bash
python3 test_login.py --mode correct
```

4. Ejecutar prueba con credenciales incorrectas:
```bash
python3 test_login.py --mode incorrect
```

5. Desactivar el entorno virtual:
```bash
deactivate
```

#### Método sin entorno virtual (no recomendado)

1. Instalar dependencias:
```bash
pip install -r requirements.txt
```

2. Ejecutar prueba con credenciales correctas:
```bash
python3 test_login.py --mode correct
```

3. Ejecutar prueba con credenciales incorrectas:
```bash
python3 test_login.py --mode incorrect
```

### Ejecutar en Jenkins

1. Crear un nuevo pipeline en Jenkins
2. Configurar el pipeline para usar el repositorio
3. Jenkins automáticamente detectará el `Jenkinsfile` y ejecutará el pipeline

**Importante:** El job debe estar configurado como **Pipeline**, no como Freestyle Project. Si solo ves operaciones de git en la salida y no mensajes de los tests, consulta `DIAGNOSTICO_JENKINS.md` para solucionar el problema.

### Salida Esperada

Cuando los tests se ejecutan correctamente, deberías ver mensajes claros como:
- `✓ LOGIN SUCCESS - TEST PASSED` (para credenciales correctas)
- `✓ LOGIN CORRECTLY REJECTED - TEST PASSED` (para credenciales incorrectas)
- `SCRIPT FINALIZADO EXITOSAMENTE`

Si no ves estos mensajes, consulta `DIAGNOSTICO_JENKINS.md` para diagnóstico y solución.

## Estructura del Pipeline

El pipeline tiene las siguientes etapas:

1. **Setup**: Configura el entorno de prueba e instala dependencias
2. **Test Login - Correct Credentials**: Prueba el login con credenciales correctas
3. **Test Login - Incorrect Credentials**: Prueba el login con credenciales incorrectas
4. **Report Results**: Genera un resumen de los resultados

## Configuración

Las credenciales de prueba están definidas en `test_login.py`:
- Para credenciales correctas: Actualizar `CORRECT_USERNAME` y `CORRECT_PASSWORD`
- Para credenciales incorrectas: Ya están configuradas con valores inválidos

**Nota**: En un entorno de producción, las credenciales deben almacenarse de forma segura usando Jenkins Credentials o variables de entorno.

## Notas

- El script usa Selenium en modo headless (sin interfaz gráfica)
- El script intenta detectar automáticamente los campos del formulario usando múltiples selectores
- Los tiempos de espera pueden ajustarse según la velocidad de respuesta del sitio