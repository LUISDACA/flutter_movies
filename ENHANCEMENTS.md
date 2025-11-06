# Mejoras Opcionales y Extensiones

## 🎨 Mejoras de UI/UX

### 1. Animaciones Mejoradas

#### Hero Animation Personalizada
Agrega transiciones suaves entre pantallas:

```dart
// En home_screen.dart, dentro de _buildMovieCard
Hero(
  tag: 'movie-${movie.id}',
  child: CachedNetworkImage(...),
)

// En movie_detail_screen.dart
Hero(
  tag: 'movie-${widget.movieId}',
  child: CachedNetworkImage(...),
)
```

#### Animación de Carga
```dart
// Shimmer effect mientras cargan las imágenes
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: double.infinity,
    height: 200,
    color: Colors.white,
  ),
)
```

### 2. Pull to Refresh

```dart
// En home_screen.dart
RefreshIndicator(
  onRefresh: _loadData,
  child: CustomScrollView(...),
)
```

### 3. Modo Oscuro

```dart
// En main.dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
)
```

---

## 🚀 Funcionalidades Adicionales

### 1. Favoritos con SharedPreferences

```dart
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_movies';
  
  Future<void> addFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    favorites.add(movieId.toString());
    await prefs.setStringList(_key, favorites);
  }
  
  Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    favorites.remove(movieId.toString());
    await prefs.setStringList(_key, favorites);
  }
  
  Future<bool> isFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    return favorites.contains(movieId.toString());
  }
}
```

### 2. Historial de Búsqueda

```dart
class SearchHistory {
  static const String _key = 'search_history';
  
  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
  
  Future<void> addSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, query);
    // Mantener solo las últimas 10 búsquedas
    if (history.length > 10) {
      history.removeLast();
    }
    await prefs.setStringList(_key, history.toSet().toList());
  }
}
```

### 3. Filtros por Género

```dart
// En tmdb_service.dart
Future<List<Movie>> getMoviesByGenre(int genreId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'),
  );
  // ... procesar respuesta
}

// Géneros comunes:
// 28: Action
// 35: Comedy
// 18: Drama
// 27: Horror
// 10749: Romance
// 878: Science Fiction
```

### 4. Películas Similares

```dart
// En tmdb_service.dart
Future<List<Movie>> getSimilarMovies(int movieId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'),
  );
  // ... procesar respuesta
}
```

---

## 📊 Gestión de Estado

### Provider (Recomendado para proyectos medianos)

```dart
// pubspec.yaml
dependencies:
  provider: ^6.0.0

// movie_provider.dart
import 'package:flutter/foundation.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  
  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _movies = await TMDBService().getPopularMovies();
    } catch (e) {
      print('Error: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
}

// En main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MovieProvider()),
  ],
  child: MyApp(),
)

// En home_screen.dart
final movieProvider = Provider.of<MovieProvider>(context);
movieProvider.loadMovies();
```

---

## 🔍 Búsqueda Avanzada

### Búsqueda con Debounce

```dart
import 'dart:async';

Timer? _debounce;

void _onSearchChanged(String query) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  
  _debounce = Timer(const Duration(milliseconds: 500), () {
    if (query.isNotEmpty) {
      _searchMovies(query);
    }
  });
}

// En el TextField
TextField(
  onChanged: _onSearchChanged,
)
```

### Sugerencias de Búsqueda

```dart
// Usa SearchDelegate de Flutter
class MovieSearchDelegate extends SearchDelegate<Movie> {
  final TMDBService tmdbService;
  
  MovieSearchDelegate(this.tmdbService);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    // Implementar búsqueda
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    // Implementar sugerencias
  }
}
```

---

## 💾 Caché Local

### Usar Hive para Base de Datos Local

```dart
// pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

// main.dart
await Hive.initFlutter();
await Hive.openBox<Movie>('movies');

// Guardar películas
final box = Hive.box<Movie>('movies');
await box.put(movie.id, movie);

// Cargar películas
final movie = box.get(movieId);
```

---

## 📈 Analytics y Tracking

### Firebase Analytics

```dart
// pubspec.yaml
dependencies:
  firebase_analytics: ^10.0.0

// Trackear eventos
FirebaseAnalytics.instance.logEvent(
  name: 'movie_viewed',
  parameters: {
    'movie_id': movieId,
    'movie_title': movieTitle,
  },
);
```

---

## 🌐 Internacionalización

```dart
// pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

// Crear archivos de traducción
// l10n/app_es.arb
{
  "explore": "Explorar",
  "topMovies": "Películas Populares",
  "trailers": "Trailers"
}

// l10n/app_en.arb
{
  "explore": "Explore",
  "topMovies": "Top Movies",
  "trailers": "Trailers"
}
```

---

## 🎬 Reproducción de Video Integrada

### Usar video_player

```dart
// pubspec.yaml
dependencies:
  video_player: ^2.7.0
  youtube_player_flutter: ^8.1.0

// Reproducir video de YouTube dentro de la app
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayer(
  controller: YoutubePlayerController(
    initialVideoId: videoId,
    flags: YoutubePlayerFlags(autoPlay: false),
  ),
)
```

---

## 🔐 Seguridad de API Key

### Usar Variables de Entorno

```dart
// Crear archivo .env
TMDB_API_KEY=tu_api_key_aqui

// pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0

assets:
  - .env

// Cargar en main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// Usar en tmdb_service.dart
static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
```

---

## 📱 Notificaciones Push

### Para Nuevos Estrenos

```dart
// pubspec.yaml
dependencies:
  firebase_messaging: ^14.0.0

// Solicitar permisos
await FirebaseMessaging.instance.requestPermission();

// Recibir notificaciones
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Nueva película: ${message.notification?.title}');
});
```

---

## 🎯 Optimizaciones de Rendimiento

### 1. Lazy Loading de Imágenes

```dart
ListView.builder(
  cacheExtent: 200, // Pre-cargar imágenes
  itemBuilder: (context, index) {
    return _buildMovieCard(_movies[index]);
  },
)
```

### 2. Paginación Infinita

```dart
ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

void _onScroll() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    _loadMoreMovies();
  }
}
```

### 3. Compresión de Imágenes

```dart
// Usar URLs de menor calidad para thumbnails
String get thumbnailUrl =>
    'https://image.tmdb.org/t/p/w200$posterPath';

String get fullQualityUrl =>
    'https://image.tmdb.org/t/p/original$posterPath';
```

---

## 🧪 Testing

### Unit Tests

```dart
// test/tmdb_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TMDBService', () {
    test('getPopularMovies retorna lista', () async {
      final service = TMDBService();
      final movies = await service.getPopularMovies();
      expect(movies, isNotEmpty);
    });
  });
}
```

### Widget Tests

```dart
testWidgets('HomeScreen muestra películas', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: HomeScreen()));
  await tester.pumpAndSettle();
  
  expect(find.text('Explore'), findsOneWidget);
  expect(find.text('Top Movies'), findsOneWidget);
});
```

---

## 📚 Recursos Adicionales

### Paquetes Útiles

- `flutter_rating_bar` - Barras de calificación personalizadas
- `share_plus` - Compartir películas
- `flutter_staggered_grid_view` - Grids avanzados
- `lottie` - Animaciones Lottie
- `connectivity_plus` - Detectar conexión a internet

### Links Útiles

- TMDB API Docs: https://developers.themoviedb.org/3
- Flutter Packages: https://pub.dev
- Flutter Cookbook: https://flutter.dev/docs/cookbook

---

¡Estas mejoras llevarán tu app al siguiente nivel! 🚀
