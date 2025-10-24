# Odontograma Digital

## Descripción

Este componente implementa un odontograma digital interactivo para registro dental. Permite visualizar, editar y exportar información sobre el estado de la dentadura de un paciente en formato JSON.

## Características

### 1. Visualización de Dentadura Completa
- **32 dientes adultos** usando el sistema de numeración FDI
- Arcada superior: dientes 18-11 (cuadrante 1) y 21-28 (cuadrante 2)
- Arcada inferior: dientes 48-41 (cuadrante 4) y 31-38 (cuadrante 3)

### 2. Estados de Dientes
El odontograma soporta los siguientes estados dentales:

- **Sano** (blanco): Diente saludable sin condiciones
- **Caries** (rojo): Diente con caries
- **Extracción** (azul): Diente extraído o ausente
- **Restauración** (verde): Diente con restauración/obturación
- **Endodoncia** (rosa): Diente con tratamiento de conducto
- **Implante** (morado): Implante dental

### 3. Modos de Selección
- **Individual**: Selecciona y aplica estado a un diente a la vez
- **Múltiple**: Selecciona varios dientes y aplica el estado a todos simultáneamente

### 4. Gestión de Notas
- Agregar notas para tratamientos específicos
- Asociar notas a piezas dentales
- Registro de fecha automático
- Eliminar notas existentes

### 5. Exportación de Datos
El odontograma genera un JSON con la siguiente estructura:

```json
{
  "patient_id": "12345",
  "patient_name": "Juan Pérez",
  "record_date": "2025-10-24",
  "timestamp": "2025-10-24T13:54:08.160Z",
  "teeth": {
    "18": { "state": "healthy", "notes": "" },
    "17": { "state": "cavity", "notes": "" },
    "16": { "state": "restoration", "notes": "" },
    ...
  },
  "notes": [
    {
      "tooth": "14",
      "treatment": "Revisión semestral con...",
      "date": "2025-10-24",
      "timestamp": 1698155648160
    }
  ],
  "summary": {
    "total_teeth": 32,
    "healthy": 28,
    "cavity": 2,
    "extraction": 0,
    "restoration": 1,
    "endodontics": 1,
    "implant": 0
  }
}
```

## Uso

### 1. Abrir el Odontograma
Abra el archivo `odontogram.html` en un navegador web moderno.

### 2. Ingresar Información del Paciente
- **ID del Paciente**: Identificador único (requerido)
- **Nombre del Paciente**: Nombre completo
- **Fecha de Registro**: Fecha del examen (por defecto: hoy)

### 3. Seleccionar Estado Dental
1. Haga clic en uno de los botones de estado en la barra de herramientas:
   - Sano
   - Caries
   - Extracción
   - Restauración
   - Endodoncia
   - Implante

### 4. Aplicar Estado a Dientes

#### Modo Individual (por defecto):
1. Seleccione el estado deseado
2. Haga clic en el diente para aplicar el estado inmediatamente

#### Modo Múltiple:
1. Active el modo "Múltiple"
2. Seleccione el estado deseado
3. Haga clic en varios dientes para seleccionarlos
4. Haga clic en "Aplicar a Seleccionados"

### 5. Agregar Notas
1. En la sección "Notas de la Historia Actual"
2. Ingrese el número de pieza (ej: 14, 21)
3. Escriba el tratamiento o nota
4. Haga clic en "Agregar Nota"

### 6. Guardar y Exportar

- **Guardar Odontograma**: Guarda los datos en localStorage del navegador
- **Exportar JSON**: Descarga un archivo JSON con todos los datos
- **Limpiar Todo**: Reinicia el odontograma a su estado inicial

## Integración con Aplicación Web

### Integración Básica
Para integrar el odontograma en una aplicación web existente:

```html
<!-- Incluir en tu página HTML -->
<iframe src="odontogram.html" width="100%" height="900px"></iframe>
```

### Integración con JavaScript
Para extraer los datos del odontograma desde la página padre:

```javascript
// Función para obtener datos del odontograma
function getOdontogramData() {
  const iframe = document.getElementById('odontogram-iframe');
  const iframeWindow = iframe.contentWindow;
  
  // Llamar función del iframe
  return iframeWindow.generateJSON();
}
```

### API REST (Ejemplo)
Para enviar datos a un servidor:

```javascript
async function saveOdontogramToServer() {
  const data = generateJSON();
  
  const response = await fetch('/api/odontogram', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data)
  });
  
  return response.json();
}
```

## Sistema de Numeración Dental

El odontograma utiliza el **Sistema de Numeración FDI** (Fédération Dentaire Internationale):

### Cuadrantes:
- **Cuadrante 1**: Superior derecho (dientes 18-11)
- **Cuadrante 2**: Superior izquierdo (dientes 21-28)
- **Cuadrante 3**: Inferior izquierdo (dientes 31-38)
- **Cuadrante 4**: Inferior derecho (dientes 48-41)

### Numeración:
- Primer dígito: número de cuadrante (1-4)
- Segundo dígito: posición del diente (1-8)
  - 8: Tercer molar (muela del juicio)
  - 7: Segundo molar
  - 6: Primer molar
  - 5: Segundo premolar
  - 4: Primer premolar
  - 3: Canino
  - 2: Incisivo lateral
  - 1: Incisivo central

## Características Técnicas

### Tecnologías Utilizadas
- **HTML5**: Estructura del documento
- **CSS3**: Estilos y diseño responsive
- **JavaScript Vanilla**: Lógica de la aplicación (sin dependencias)

### Compatibilidad
- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Opera 76+

### Almacenamiento
- **localStorage**: Para guardar datos localmente en el navegador
- **Exportación JSON**: Para integración con sistemas externos

### Sin Dependencias
El odontograma es completamente autónomo y no requiere bibliotecas externas.

## Próximas Mejoras

- [ ] Agregar vista de superficies dentales (mesial, distal, oclusal, vestibular, lingual)
- [ ] Implementar historial de cambios
- [ ] Agregar más estados dentales (prótesis, ortodoncia, etc.)
- [ ] Integración con backend para persistencia
- [ ] Generación de reportes PDF
- [ ] Soporte para dentición temporal (dientes de leche)
- [ ] Modo de comparación entre visitas

## Soporte

Para preguntas o problemas, por favor cree un issue en el repositorio de GitHub.

## Licencia

Este componente es parte del proyecto clip-testing.
