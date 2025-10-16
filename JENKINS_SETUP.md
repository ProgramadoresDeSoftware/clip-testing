# Configuración de Jenkins

## Pasos para configurar el pipeline en Jenkins

### 1. Requisitos previos en Jenkins

Este pipeline utiliza Docker para proporcionar un entorno consistente con todas las dependencias necesarias.

Asegúrese de que el agente de Jenkins tenga instalado:

- **Docker** (para ejecutar el contenedor con Python y dependencias)
  ```bash
  docker --version
  ```

- **Permisos de Docker** para el usuario de Jenkins
  ```bash
  # El usuario jenkins debe tener permisos para ejecutar docker
  sudo usermod -aG docker jenkins
  ```

**Nota:** Ya NO es necesario instalar manualmente Python 3, pip3, Chrome o ChromeDriver en el host de Jenkins, ya que el pipeline utiliza un contenedor Docker (`python:3.9-slim`) que instala automáticamente todas estas dependencias durante la ejecución.

### 2. Crear nuevo Pipeline en Jenkins

1. Acceder a Jenkins dashboard
2. Hacer clic en "New Item" / "Nueva Tarea"
3. Introducir nombre: `login-test-pipeline`
4. Seleccionar "Pipeline"
5. Hacer clic en "OK"

### 3. Configurar el Pipeline

En la configuración del pipeline:

#### Sección "General"
- Marcar "GitHub project" (opcional)
- URL del proyecto: `https://github.com/ProgramadoresDeSoftware/clip-testing/`

#### Sección "Build Triggers"
Opciones recomendadas:
- "Poll SCM": `H/5 * * * *` (verifica cambios cada 5 minutos)
- "GitHub hook trigger for GITScm polling" (si tiene webhook configurado)

#### Sección "Pipeline"
- **Definition**: Pipeline script from SCM
- **SCM**: Git
- **Repository URL**: `https://github.com/ProgramadoresDeSoftware/clip-testing.git`
- **Credentials**: Agregar si el repositorio es privado
- **Branch Specifier**: `*/main` o `*/copilot/add-login-access-pipeline`
- **Script Path**: `Jenkinsfile`

### 4. Guardar y ejecutar

1. Hacer clic en "Save" / "Guardar"
2. Hacer clic en "Build Now" / "Construir Ahora"
3. Ver el progreso en "Console Output" / "Salida de Consola"

## Estructura del Pipeline

El pipeline utiliza un contenedor Docker (`python:3.9-slim`) para garantizar un entorno consistente y ejecuta las siguientes etapas:

```
1. Setup (en contenedor Docker)
   └─ Actualiza el sistema e instala dependencias del sistema
   └─ Instala Google Chrome y ChromeDriver
   └─ Instala dependencias de Python (selenium, requests)
   └─ Verifica las instalaciones

2. Test Login - Correct Credentials
   └─ Ejecuta: python3 test_login.py --mode correct
   └─ Verifica acceso con credenciales correctas

3. Test Login - Incorrect Credentials
   └─ Ejecuta: python3 test_login.py --mode incorrect
   └─ Verifica rechazo con credenciales incorrectas

4. Report Results
   └─ Muestra resumen de resultados
```

### Ventajas del uso de Docker:
- **Consistencia**: El mismo entorno en todos los agentes de Jenkins
- **Portabilidad**: No requiere configuración manual del host
- **Aislamiento**: Cada ejecución usa un contenedor limpio
- **Mantenibilidad**: Fácil actualizar versiones cambiando la imagen

## Configuración de Credenciales Seguras

Para un entorno de producción, se recomienda usar Jenkins Credentials:

### Método 1: Variables de entorno en Jenkins

1. Ir a "Manage Jenkins" > "Configure System"
2. Agregar variables de entorno globales:
   - `LOGIN_USERNAME_CORRECT`
   - `LOGIN_PASSWORD_CORRECT`

3. Modificar el Jenkinsfile para usar estas variables:
```groovy
environment {
    CORRECT_USERNAME = credentials('login-username-correct')
    CORRECT_PASSWORD = credentials('login-password-correct')
}
```

4. Modificar test_login.py para leer de variables de entorno:
```python
import os
CORRECT_USERNAME = os.getenv('CORRECT_USERNAME', 'test_user@example.com')
CORRECT_PASSWORD = os.getenv('CORRECT_PASSWORD', 'correct_password123')
```

### Método 2: Jenkins Credentials Plugin

1. Ir a "Manage Jenkins" > "Manage Credentials"
2. Agregar "Username with password"
3. ID: `login-credentials`
4. Username: usuario válido
5. Password: contraseña válida

## Troubleshooting

### Error: "python3: not found"
**Solución**: Este error ya está resuelto usando Docker. Asegúrese de que:
- Docker está instalado y corriendo en el host de Jenkins
- El usuario jenkins tiene permisos para ejecutar Docker
- El plugin Docker Pipeline está instalado en Jenkins

### Error: "Cannot connect to the Docker daemon"
**Solución**: Verificar permisos de Docker para el usuario jenkins:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Error: "No module named 'selenium'"
**Solución**: Este error se resuelve automáticamente durante la etapa Setup. Si persiste, verificar que el contenedor Docker puede acceder a internet para descargar paquetes.

### Error: "chromedriver not found"
**Solución**: Este error se resuelve automáticamente durante la etapa Setup del pipeline, que instala ChromeDriver. Si persiste, verificar los logs de la etapa Setup.

### Error: "No se pudo encontrar el campo de usuario"
**Solución**: El sitio puede haber cambiado. Inspeccionar el HTML del formulario y actualizar los selectores en test_login.py

## Ejecución Manual

Para probar localmente antes de ejecutar en Jenkins:

```bash
# Clonar repositorio
git clone https://github.com/ProgramadoresDeSoftware/clip-testing.git
cd clip-testing

# Instalar dependencias
pip3 install -r requirements.txt

# Ejecutar pruebas
python3 test_login.py --mode correct
python3 test_login.py --mode incorrect
```

## Resultados Esperados

### Test con credenciales correctas:
- ✓ Se carga la página de login
- ✓ Se encuentran los campos de formulario
- ✓ Se envían las credenciales
- ✓ Se verifica el resultado (puede variar según credenciales reales)

### Test con credenciales incorrectas:
- ✓ Se carga la página de login
- ✓ Se encuentran los campos de formulario
- ✓ Se envían las credenciales incorrectas
- ✓ Se verifica que se rechaza el acceso (mensaje de error o permanece en login)
