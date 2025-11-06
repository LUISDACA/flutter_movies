# Movie App - Flutter

Aplicación de películas desarrollada en Flutter que replica el diseño proporcionado. Utiliza la API de The Movie Database (TMDB) para mostrar información de películas, trailers, cast y más.

## 📱 Características

- 🎬 Explorar películas populares y en cartelera
- 🔍 Búsqueda de películas
- 📅 Selector de fechas interactivo
- 🎥 Visualización de trailers
- ⭐ Detalles completos de películas con calificaciones
- 👥 Información del cast y crew
- 🎨 Diseño moderno y elegante

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK (3.0.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Cuenta en TMDB para obtener API Key

### Paso 1: Obtener API Key de TMDB

1. Visita [https://www.themoviedb.org/](https://www.themoviedb.org/)
2. Crea una cuenta gratuita
3. Ve a Settings > API
4. Solicita una API Key (es gratis y se aprueba instantáneamente)
5. Copia tu API Key (v3 auth)

### Paso 2: Configurar el proyecto

1. Clona o descarga este proyecto

2. Navega a la carpeta del proyecto:
```bash
cd movie_app
```

3. Abre el archivo `lib/services/tmdb_service.dart`

4. Reemplaza `TU_API_KEY_AQUI` con tu API Key de TMDB:
```dart
static const String apiKey = 'tu_api_key_aqui';
```

5. Instala las dependencias:
```bash
flutter pub get
```

### Paso 3: Ejecutar la aplicación

Para Android:
```bash
flutter run
```

Para iOS:
```bash
flutter run
```

Para Web:
```bash
flutter run -d chrome
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── movie.dart
│   ├── movie_detail.dart
│   ├── cast.dart
│   └── video.dart
├── services/                 # Servicios de API
│   └── tmdb_service.dart
└── screens/                  # Pantallas de la aplicación
    ├── home_screen.dart
    └── movie_detail_screen.dart
```

## 🎨 Pantallas

### Pantalla Principal (Home)
- Barra de búsqueda
- Título "Explore Top Movies"
- Selector de fechas horizontal
- Grid de películas populares
- Sección de trailers

### Pantalla de Detalles
- Imagen de fondo de la película
- Información básica (año, tipo, duración, director)
- Calificación con estrellas
- Resumen de la trama
- Géneros
- Cast con fotos
- Trailers reproducibles

## 📦 Dependencias

- **http**: Para realizar peticiones HTTP a la API
- **cached_network_image**: Para cachear y mostrar imágenes
- **intl**: Para formateo de fechas
- **url_launcher**: Para abrir trailers en YouTube
- **cupertino_icons**: Iconos de iOS

## 🔧 Configuración Adicional

### Android

En `android/app/src/main/AndroidManifest.xml`, añade el permiso de internet:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS

En `ios/Runner/Info.plist`, añade:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🌐 API Endpoints Utilizados

- `/movie/popular` - Películas populares
- `/movie/now_playing` - Películas en cartelera
- `/movie/{id}` - Detalles de película
- `/movie/{id}/credits` - Cast y crew
- `/movie/{id}/videos` - Trailers y videos
- `/search/movie` - Búsqueda de películas

## 🎯 Funcionalidades Principales

1. **Explorar Películas**: Muestra películas populares en una grid
2. **Búsqueda**: Busca películas por nombre
3. **Selector de Fechas**: Navegación por fechas (interfaz visual)
4. **Detalles Completos**: Información detallada al hacer clic en una película
5. **Trailers**: Visualización de trailers de YouTube
6. **Cast**: Información del reparto con fotos

## 🎨 Paleta de Colores

- Primary: `#E91E63` (Pink)
- Secondary: `#2C3E50` (Dark Blue)
- Background: `#FFFFFF` (White)
- Text: `#2C3E50` (Dark Blue)
- IMDb: `#F5C518` (Yellow)

## 📝 Notas Importantes

- La API de TMDB tiene límites de peticiones (40 requests por 10 segundos)
- Las imágenes se cargan desde los servidores de TMDB
- Los trailers se abren en YouTube mediante url_launcher
- La aplicación requiere conexión a internet

## 🐛 Solución de Problemas

### Error: API Key inválida
- Verifica que copiaste correctamente tu API Key
- Asegúrate de usar la API Key v3 (no v4)

### No se cargan las imágenes
- Verifica tu conexión a internet
- Comprueba los permisos de internet en Android/iOS

### No se abren los trailers
- Asegúrate de tener YouTube instalado o un navegador
- Verifica que url_launcher esté correctamente configurado

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

Desarrollado como proyecto de demostración de Flutter.

---

¡Disfruta explorando películas! 🎬🍿
