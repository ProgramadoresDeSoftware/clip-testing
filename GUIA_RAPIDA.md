# Guía Rápida - Odontograma Digital

## 🚀 Inicio Rápido (5 minutos)

### 1. Abrir el Odontograma
Simplemente abre el archivo `odontogram.html` en tu navegador web favorito:
- **Chrome/Edge**: Arrastra el archivo a una ventana del navegador
- **Firefox**: Menú → Abrir Archivo → Selecciona `odontogram.html`
- **Safari**: Archivo → Abrir Archivo → Selecciona `odontogram.html`

### 2. Completar Información del Paciente
```
ID del Paciente: PAC-001      [Campo requerido]
Nombre: Juan Pérez            [Opcional]
Fecha: 2025-10-24            [Fecha de hoy por defecto]
```

### 3. Aplicar Estados a Dientes

#### Modo Rápido (Individual):
1. Click en botón "Caries" 🔴
2. Click en diente 17
3. El diente se marca como caries automáticamente

#### Modo Múltiple:
1. Activa radio button "Múltiple"
2. Click en botón "Restauración" 🟢
3. Click en dientes 14, 15, 16 (se seleccionan)
4. Click en botón naranja "Aplicar a Seleccionados"
5. Todos los dientes seleccionados cambian a verde

### 4. Agregar Notas
```
Pieza: 14
Tratamiento: Restauración de amalgama completada
[Click en "Agregar Nota"]
```
La nota aparece en la lista de la derecha con la fecha actual.

### 5. Exportar Datos
- **Botón "Guardar Odontograma"**: Guarda en localStorage del navegador
- **Botón "Exportar JSON"**: Descarga archivo JSON con todos los datos
- **Botón "Limpiar Todo"**: Reinicia el odontograma

## 📊 Estructura del JSON Exportado

```json
{
  "patient_id": "PAC-001",
  "patient_name": "Juan Pérez",
  "record_date": "2025-10-24",
  "teeth": {
    "17": { "state": "cavity" },      // Diente con caries
    "14": { "state": "restoration" }  // Diente restaurado
  },
  "notes": [
    {
      "tooth": "14",
      "treatment": "Restauración completada",
      "date": "2025-10-24"
    }
  ],
  "summary": {
    "total_teeth": 32,
    "cavity": 1,
    "restoration": 1,
    "healthy": 30
  }
}
```

## 🎨 Estados Disponibles

| Estado | Color | Descripción |
|--------|-------|-------------|
| Sano | ⬜ Blanco | Diente saludable |
| Caries | 🔴 Rojo | Diente con caries |
| Extracción | 🔵 Azul | Diente extraído/ausente |
| Restauración | 🟢 Verde | Diente con obturación |
| Endodoncia | 🩷 Rosa | Tratamiento de conducto |
| Implante | 🟣 Morado | Implante dental |

## 🦷 Sistema de Numeración (FDI)

```
        Arcada Superior
18 17 16 15 14 13 12 11 | 21 22 23 24 25 26 27 28
        Derecha         |         Izquierda
-------------------------+------------------------
        Izquierda       |         Derecha
38 37 36 35 34 33 32 31 | 41 42 43 44 45 46 47 48
        Arcada Inferior
```

## ⚡ Atajos de Teclado (Próximamente)
- `S`: Seleccionar estado "Sano"
- `C`: Seleccionar estado "Caries"
- `E`: Seleccionar estado "Extracción"
- `R`: Seleccionar estado "Restauración"
- `Ctrl+S`: Guardar odontograma
- `Ctrl+E`: Exportar JSON

## 🔧 Solución de Problemas

### El odontograma no se muestra correctamente
- Asegúrate de usar un navegador moderno (Chrome 90+, Firefox 88+, Safari 14+)
- Abre la consola del navegador (F12) para ver errores

### No puedo descargar el JSON
- Verifica que el navegador permita descargas
- Algunos navegadores bloquean descargas de archivos locales

### Los cambios no se guardan
- "Guardar Odontograma" guarda en localStorage (datos locales del navegador)
- "Exportar JSON" descarga un archivo que debes guardar manualmente
- Para persistencia permanente, necesitas integrar con un backend

## 📱 Uso en Dispositivos Móviles

El odontograma es responsive y funciona en tablets y móviles:
- Use dos dedos para hacer zoom si es necesario
- Los botones son suficientemente grandes para uso táctil
- La vista se adapta a pantallas pequeñas

## 🔗 Siguientes Pasos

1. **Integración Backend**: Ver `INTEGRACION_EJEMPLOS.md`
2. **Documentación Completa**: Ver `ODONTOGRAMA_README.md`
3. **Personalización**: Editar `odontogram.html` según necesidades

## 💡 Consejos

- **Usa ID únicos**: El patient_id debe ser único para cada paciente
- **Agrega notas detalladas**: Las notas ayudan al seguimiento
- **Exporta regularmente**: Descarga JSON como respaldo
- **Revisa el resumen**: El summary muestra estadísticas útiles

## 📞 Soporte

Para preguntas o problemas:
1. Revisa `ODONTOGRAMA_README.md` para documentación detallada
2. Revisa `INTEGRACION_EJEMPLOS.md` para ejemplos de código
3. Crea un issue en el repositorio de GitHub

---

**¿Listo para empezar?** → Abre `odontogram.html` en tu navegador y comienza a registrar información dental.
