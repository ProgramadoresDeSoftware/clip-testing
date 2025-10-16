# Pipeline de Prueba de Login - clasesprofesores.net

Este proyecto contiene un pipeline de Jenkins para probar el acceso al login del sitio web clasesprofesores.net/login.

## Descripción

El pipeline automatiza las pruebas de login con dos escenarios:
1. **Credenciales correctas**: Verifica que el formulario de login acepta credenciales válidas
2. **Credenciales incorrectas**: Verifica que el formulario de login rechaza credenciales inválidas

## Archivos del Proyecto

- `Jenkinsfile`: Definición del pipeline de Jenkins
- `test_login.py`: Script de prueba en Python usando Selenium
- `requirements.txt`: Dependencias de Python necesarias

## Requisitos

### Para ejecutar localmente:
- Python 3.6+
- Chrome/Chromium browser
- ChromeDriver

### Para ejecutar en Jenkins:
- Jenkins con soporte para pipelines
- Docker instalado en el agente de Jenkins
- Plugin Docker Pipeline instalado en Jenkins
- Usuario jenkins con permisos para ejecutar Docker

**Nota**: El pipeline usa Docker para proporcionar un entorno con Python 3, Chrome y ChromeDriver pre-configurados. Ya no es necesario instalar estas dependencias manualmente en el host.

## Uso

### Ejecutar localmente

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