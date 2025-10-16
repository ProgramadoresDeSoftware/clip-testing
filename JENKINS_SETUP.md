# Configuración de Jenkins

## Pasos para configurar el pipeline en Jenkins

### 1. Requisitos previos en Jenkins

Asegúrese de que el agente de Jenkins tenga instalado:

- **Python 3** (versión 3.7 o superior)
  ```bash
  python3 --version
  ```

- **pip3** (gestor de paquetes de Python)
  ```bash
  pip3 --version
  ```

- **Google Chrome**
  ```bash
  # Para Debian/Ubuntu
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update
  sudo apt-get install -y google-chrome-stable
  ```

- **ChromeDriver** (compatible con la versión de Chrome instalada)
  ```bash
  # Descargar ChromeDriver desde https://chromedriver.chromium.org/
  # O usar el siguiente script de ejemplo:
  CHROME_VERSION=$(google-chrome --version | sed -E 's/.* ([0-9]+)\..*/\1/')
  wget "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}" -O /tmp/chromedriver_version
  CHROMEDRIVER_VERSION=$(cat /tmp/chromedriver_version)
  wget "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip
  sudo unzip -o /tmp/chromedriver.zip -d /usr/local/bin/
  sudo chmod +x /usr/local/bin/chromedriver
  ```

**Nota:** El pipeline instalará automáticamente las dependencias de Python (selenium, requests) usando pip3 durante la etapa de Setup.

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

El pipeline ejecuta las siguientes etapas en el agente de Jenkins:

```
1. Setup
   └─ Verifica instalación de Python 3 y pip3
   └─ Instala dependencias de Python (selenium, requests)
   └─ Verifica instalación de Google Chrome
   └─ Verifica instalación de ChromeDriver

2. Test Login - Correct Credentials
   └─ Ejecuta: python3 test_login.py --mode correct
   └─ Verifica acceso con credenciales correctas

3. Test Login - Incorrect Credentials
   └─ Ejecuta: python3 test_login.py --mode incorrect
   └─ Verifica rechazo con credenciales incorrectas

4. Report Results
   └─ Muestra resumen de resultados
```

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

### Error: "Invalid agent type 'docker' specified"
**Solución**: Este error ocurre cuando Jenkins no tiene el plugin Docker Pipeline instalado. El Jenkinsfile ha sido actualizado para usar `agent any` en lugar de `agent docker`, por lo que este error ya está resuelto. Asegúrese de que tiene todos los requisitos previos instalados en el agente de Jenkins.

### Error: "python3: not found"
**Solución**: Python 3 debe estar instalado en el agente de Jenkins. Instalar con:
```bash
# Para Debian/Ubuntu
sudo apt-get update
sudo apt-get install -y python3 python3-pip
```

### Error: "No module named 'selenium'"
**Solución**: Las dependencias de Python se instalan automáticamente durante la etapa Setup. Si persiste:
```bash
pip3 install --user -r requirements.txt
```

### Error: "chromedriver not found"
**Solución**: ChromeDriver debe estar instalado en el agente de Jenkins. Ver la sección de requisitos previos para instrucciones de instalación.

### Error: "Chrome not found"
**Solución**: Google Chrome debe estar instalado en el agente de Jenkins. Ver la sección de requisitos previos para instrucciones de instalación.

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
