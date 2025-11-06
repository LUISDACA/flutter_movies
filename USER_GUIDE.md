# Guía de Uso - Movie App

## 📱 Funcionalidades de la Aplicación

### 1. Pantalla Principal (Home Screen)

#### Barra de Búsqueda
- **Ubicación**: Parte superior de la pantalla
- **Función**: Buscar películas por título
- **Cómo usar**: 
  1. Toca la barra de búsqueda
  2. Escribe el nombre de la película
  3. Presiona Enter o el botón de búsqueda
  4. Los resultados se mostrarán en el grid de películas

#### Selector de Fechas
- **Ubicación**: Debajo del título "Top Movies"
- **Función**: Navegación visual por fechas
- **Características**:
  - Muestra 5 días (ayer, hoy, y 3 días futuros)
  - El día actual está resaltado en rosa
  - Los demás días tienen fondo gris claro
  - Al tocar una fecha, se resalta visualmente

#### Grid de Películas
- **Ubicación**: Centro de la pantalla
- **Función**: Mostrar pósters de películas populares
- **Características**:
  - Muestra hasta 6 películas en formato grid (2 columnas)
  - Cada póster es clickeable
  - Animación al hacer tap
  - Imágenes en alta calidad desde TMDB
- **Cómo usar**:
  1. Desplázate verticalmente para ver más películas
  2. Toca cualquier póster para ver los detalles

#### Sección de Trailers
- **Ubicación**: Parte inferior
- **Función**: Vista previa rápida de trailers
- **Características**:
  - Lista horizontal scrolleable
  - Miniaturas de YouTube
  - Icono de play superpuesto
  - Muestra trailers de películas populares
- **Cómo usar**:
  1. Desliza horizontalmente para ver más trailers
  2. Toca un trailer para abrirlo en YouTube

---

### 2. Pantalla de Detalles (Movie Detail Screen)

#### Imagen Hero
- **Ubicación**: Parte superior
- **Función**: Mostrar imagen principal de la película
- **Características**:
  - Imagen de fondo en pantalla completa
  - Gradiente para mejor legibilidad
  - Botón de retroceso en la esquina superior izquierda
  - Animación hero al navegar desde la pantalla principal

#### Card de Información
- **Ubicación**: Debajo de la imagen hero
- **Función**: Mostrar datos clave de la película
- **Incluye**:
  - **Título**: Nombre completo de la película
  - **Badge IMDb**: Indicador amarillo oficial
  - **Calificación**: Sistema de estrellas (5 estrellas máximo)
  - **Año**: Año de estreno
  - **Tipo**: Género principal
  - **Duración**: Horas y minutos
  - **Director**: Nombre del director

#### Plot Summary (Resumen)
- **Ubicación**: Debajo del card de información
- **Función**: Sinopsis de la película
- **Características**:
  - Texto completo de la descripción
  - Formato legible con espaciado
  - En español (si está disponible)

#### Géneros
- **Ubicación**: Debajo del resumen
- **Función**: Mostrar todos los géneros de la película
- **Características**:
  - Pills o badges con fondo gris
  - Múltiples géneros (Drama, Romance, Thriller, etc.)
  - Diseño adaptativo según cantidad de géneros

#### Cast (Reparto)
- **Ubicación**: Sección inferior
- **Función**: Mostrar actores principales
- **Características**:
  - Lista horizontal scrolleable
  - Fotos circulares de los actores
  - Nombre del actor
  - Nombre del personaje
  - Muestra hasta 10 actores principales
- **Cómo usar**:
  1. Desliza horizontalmente para ver más actores
  2. Cada card muestra foto, nombre real y nombre del personaje

#### Trailers
- **Ubicación**: Final de la pantalla
- **Función**: Ver trailers oficiales
- **Características**:
  - Miniaturas de alta calidad
  - Título del trailer
  - Botón de play grande
  - Gradient overlay para mejor visibilidad
- **Cómo usar**:
  1. Toca el trailer que quieras ver
  2. Se abrirá YouTube automáticamente
  3. Si no tienes YouTube, se abrirá en el navegador

---

## 🎯 Flujo de Navegación

```
Pantalla Principal
    ↓ (Tap en película)
Pantalla de Detalles
    ↓ (Botón atrás)
Pantalla Principal
```

## ⚡ Gestos y Interacciones

### En Pantalla Principal:
- **Scroll vertical**: Ver más películas
- **Scroll horizontal (trailers)**: Ver más trailers
- **Tap en película**: Ir a detalles
- **Tap en fecha**: Cambiar fecha seleccionada (visual)
- **Escribir en búsqueda + Enter**: Buscar películas

### En Pantalla de Detalles:
- **Scroll vertical**: Ver todo el contenido
- **Scroll horizontal (cast)**: Ver más actores
- **Tap en trailer**: Abrir en YouTube
- **Botón atrás**: Regresar a pantalla principal
- **Swipe desde borde izquierdo**: Regresar (iOS gesture)

## 📊 Estados de la Aplicación

### Cargando
- Indicador circular de progreso
- Aparece al iniciar la app
- Aparece al cambiar de pantalla

### Error
- Mensaje de error si no hay conexión
- Placeholder si no se cargan imágenes
- Icono de error en imágenes fallidas

### Vacío
- Mensaje "No hay resumen disponible" si no hay sinopsis
- "N/A" si falta información del director o duración

## 🎨 Elementos Visuales

### Colores:
- **Rosa (#E91E63)**: Elementos seleccionados, fecha actual
- **Gris oscuro (#2C3E50)**: Textos principales
- **Gris claro (#F5F5F5)**: Fondos, elementos no seleccionados
- **Amarillo (#F5C518)**: Badge de IMDb, estrellas
- **Blanco (#FFFFFF)**: Fondo principal

### Tipografía:
- **Títulos**: Bold, 28-32px
- **Subtítulos**: SemiBold, 20-22px
- **Texto normal**: Regular, 14-16px
- **Texto pequeño**: Regular, 10-12px

### Espaciado:
- Padding general: 20px
- Espacio entre elementos: 10-15px
- Bordes redondeados: 15-20px

## 💡 Tips de Uso

1. **Mejor experiencia**: Usa con buena conexión a internet
2. **Trailers**: Requieren YouTube o navegador
3. **Búsqueda**: Funciona mejor con nombres exactos
4. **Imágenes**: Se cachean para cargar más rápido
5. **Idioma**: La app muestra contenido en español cuando está disponible

## 🔄 Actualizaciones de Datos

- **Películas populares**: Se actualizan cada vez que abres la app
- **Trailers**: Se cargan bajo demanda
- **Detalles**: Se cargan al hacer clic en una película
- **Imágenes**: Se cachean para mejorar rendimiento

## ❓ Preguntas Frecuentes

**P: ¿Por qué no veo imágenes?**
R: Verifica tu conexión a internet y que tengas configurada correctamente la API Key.

**P: ¿Por qué no se abren los trailers?**
R: Necesitas tener YouTube instalado o un navegador web configurado.

**P: ¿Puedo ver películas completas?**
R: No, la app solo muestra información y trailers. Para ver películas completas, usa servicios de streaming.

**P: ¿Los datos son en tiempo real?**
R: Sí, todos los datos vienen directamente de la base de datos de TMDB.

**P: ¿Funciona sin internet?**
R: No, la app requiere conexión a internet para funcionar.

---

¡Disfruta explorando el mundo del cine! 🎬✨
