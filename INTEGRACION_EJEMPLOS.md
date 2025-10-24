# Odontograma - Ejemplos de Integración

## 1. Integración con API REST

### Ejemplo: Guardar odontograma en el servidor

```javascript
// En odontogram.html, modificar la función saveOdontogram():

async function saveOdontogram() {
    const data = generateJSON();
    if (!data) return;

    try {
        const response = await fetch('https://api.ejemplo.com/odontograms', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer YOUR_TOKEN_HERE'
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            const result = await response.json();
            alert(`Odontograma guardado exitosamente. ID: ${result.id}`);
        } else {
            alert('Error al guardar el odontograma');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error de conexión al servidor');
    }
}
```

### Ejemplo: Cargar odontograma existente

```javascript
async function loadOdontogram(patientId) {
    try {
        const response = await fetch(`https://api.ejemplo.com/odontograms/${patientId}`, {
            headers: {
                'Authorization': 'Bearer YOUR_TOKEN_HERE'
            }
        });

        if (response.ok) {
            const data = await response.json();
            
            // Cargar información del paciente
            document.getElementById('patientId').value = data.patient_id;
            document.getElementById('patientName').value = data.patient_name;
            document.getElementById('recordDate').value = data.record_date;

            // Aplicar estados a los dientes
            Object.keys(data.teeth).forEach(toothNumber => {
                const toothData = data.teeth[toothNumber];
                applyStateToTooth(toothNumber, toothData.state);
            });

            // Cargar notas
            notes = data.notes || [];
            renderNotes();

            alert('Odontograma cargado exitosamente');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al cargar el odontograma');
    }
}
```

## 2. Integración con Iframe

### En tu aplicación principal (ejemplo con React):

```jsx
import React, { useRef, useEffect } from 'react';

function OdontogramViewer({ patientId }) {
    const iframeRef = useRef(null);

    const handleSave = () => {
        // Obtener datos del iframe
        const iframe = iframeRef.current;
        const data = iframe.contentWindow.generateJSON();
        
        // Enviar al servidor
        console.log('Guardando odontograma:', data);
    };

    return (
        <div>
            <iframe 
                ref={iframeRef}
                src="/odontogram.html" 
                width="100%" 
                height="900px"
                style={{ border: 'none' }}
            />
            <button onClick={handleSave}>Guardar</button>
        </div>
    );
}
```

## 3. Integración con Base de Datos

### Esquema de Base de Datos (PostgreSQL)

```sql
-- Tabla de odontogramas
CREATE TABLE odontograms (
    id SERIAL PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    patient_name VARCHAR(200),
    record_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data JSONB NOT NULL
);

-- Índices
CREATE INDEX idx_odontograms_patient_id ON odontograms(patient_id);
CREATE INDEX idx_odontograms_record_date ON odontograms(record_date);

-- Tabla de notas (opcional, si quieres normalizar)
CREATE TABLE odontogram_notes (
    id SERIAL PRIMARY KEY,
    odontogram_id INTEGER REFERENCES odontograms(id),
    tooth VARCHAR(2) NOT NULL,
    treatment TEXT NOT NULL,
    note_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Backend en Node.js (Express)

```javascript
const express = require('express');
const { Pool } = require('pg');

const app = express();
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});

app.use(express.json());

// Guardar odontograma
app.post('/api/odontograms', async (req, res) => {
    const { patient_id, patient_name, record_date, teeth, notes, summary } = req.body;

    try {
        const result = await pool.query(
            `INSERT INTO odontograms (patient_id, patient_name, record_date, data)
             VALUES ($1, $2, $3, $4)
             RETURNING id`,
            [patient_id, patient_name, record_date, JSON.stringify(req.body)]
        );

        res.json({ success: true, id: result.rows[0].id });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Error al guardar el odontograma' });
    }
});

// Obtener odontograma por patient_id
app.get('/api/odontograms/:patientId', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT data FROM odontograms WHERE patient_id = $1 ORDER BY created_at DESC LIMIT 1',
            [req.params.patientId]
        );

        if (result.rows.length > 0) {
            res.json(result.rows[0].data);
        } else {
            res.status(404).json({ error: 'Odontograma no encontrado' });
        }
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Error al obtener el odontograma' });
    }
});

// Obtener historial de odontogramas de un paciente
app.get('/api/odontograms/history/:patientId', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT id, record_date, created_at FROM odontograms WHERE patient_id = $1 ORDER BY record_date DESC',
            [req.params.patientId]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Error al obtener historial' });
    }
});

app.listen(3000, () => {
    console.log('API escuchando en puerto 3000');
});
```

## 4. Integración con Python/Django

### models.py

```python
from django.db import models
from django.contrib.postgres.fields import JSONField

class Odontogram(models.Model):
    patient_id = models.CharField(max_length=50, db_index=True)
    patient_name = models.CharField(max_length=200)
    record_date = models.DateField()
    data = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-record_date']
        
    def __str__(self):
        return f"Odontogram {self.patient_id} - {self.record_date}"
```

### views.py

```python
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
import json
from .models import Odontogram

@csrf_exempt
@require_http_methods(["POST"])
def save_odontogram(request):
    try:
        data = json.loads(request.body)
        
        odontogram = Odontogram.objects.create(
            patient_id=data['patient_id'],
            patient_name=data.get('patient_name', ''),
            record_date=data['record_date'],
            data=data
        )
        
        return JsonResponse({
            'success': True,
            'id': odontogram.id
        })
    except Exception as e:
        return JsonResponse({
            'error': str(e)
        }, status=500)

@require_http_methods(["GET"])
def get_odontogram(request, patient_id):
    try:
        odontogram = Odontogram.objects.filter(
            patient_id=patient_id
        ).first()
        
        if odontogram:
            return JsonResponse(odontogram.data)
        else:
            return JsonResponse({
                'error': 'Odontogram not found'
            }, status=404)
    except Exception as e:
        return JsonResponse({
            'error': str(e)
        }, status=500)
```

## 5. Comparación entre Versiones

```javascript
// Función para comparar dos odontogramas y resaltar cambios
function compareOdontograms(oldData, newData) {
    const changes = [];
    
    Object.keys(newData.teeth).forEach(toothNumber => {
        const oldState = oldData.teeth[toothNumber].state;
        const newState = newData.teeth[toothNumber].state;
        
        if (oldState !== newState) {
            changes.push({
                tooth: toothNumber,
                oldState: oldState,
                newState: newState,
                date: newData.record_date
            });
        }
    });
    
    return changes;
}
```

## 6. Exportación a PDF

```javascript
// Usando jsPDF
async function exportToPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    
    const data = generateJSON();
    
    // Título
    doc.setFontSize(18);
    doc.text('Odontograma Digital', 20, 20);
    
    // Información del paciente
    doc.setFontSize(12);
    doc.text(`Paciente: ${data.patient_name}`, 20, 30);
    doc.text(`ID: ${data.patient_id}`, 20, 40);
    doc.text(`Fecha: ${data.record_date}`, 20, 50);
    
    // Resumen
    doc.setFontSize(14);
    doc.text('Resumen:', 20, 65);
    doc.setFontSize(11);
    doc.text(`Dientes sanos: ${data.summary.healthy}`, 30, 75);
    doc.text(`Caries: ${data.summary.cavity}`, 30, 82);
    doc.text(`Extracciones: ${data.summary.extraction}`, 30, 89);
    doc.text(`Restauraciones: ${data.summary.restoration}`, 30, 96);
    
    // Guardar PDF
    doc.save(`odontogram_${data.patient_id}.pdf`);
}
```

## Notas de Seguridad

1. **Autenticación**: Siempre usar tokens de autenticación en las peticiones API
2. **Validación**: Validar todos los datos en el servidor antes de guardarlos
3. **Sanitización**: Sanitizar el patient_id para prevenir inyección SQL
4. **HTTPS**: Usar siempre HTTPS en producción
5. **CORS**: Configurar correctamente CORS en tu API
