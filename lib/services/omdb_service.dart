import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/cast.dart';
import '../models/video.dart';

class OMDbService {
  // Reemplaza con tu API Key de OMDb
  static const String apiKey = '6f5fdf8f';
  static const String baseUrl = 'http://www.omdbapi.com/';

  // Obtener películas populares (usando búsquedas predefinidas)
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    // OMDb no tiene endpoint de "populares", así que buscamos títulos conocidos
    final searches = [
      'Inception',
      'Interstellar',
      'The Dark Knight',
      'Pulp Fiction',
      'The Matrix',
      'Fight Club',
      'Forrest Gump',
      'The Godfather',
      'Parasite',
      'Joker',
      'Avengers',
      'Spider-Man',
    ];

    List<Movie> movies = [];

    for (var search in searches) {
      try {
        final movie = await _searchSingleMovie(search);
        if (movie != null) {
          movies.add(movie);
        }
      } catch (e) {
        print('Error buscando $search: $e');
      }
    }

    return movies;
  }

  // Buscar una película específica
  Future<Movie?> _searchSingleMovie(String title) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?apikey=$apiKey&t=$title'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          return Movie(
            id: data['imdbID'].hashCode,
            title: data['Title'] ?? '',
            overview: data['Plot'] ?? '',
            posterPath: data['Poster'] ?? '',
            backdropPath: data['Poster'] ?? '',
            voteAverage: _parseRating(data['imdbRating']),
            releaseDate: data['Released'] ?? '',
            genreIds: [],
          );
        }
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Buscar películas por término
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?apikey=$apiKey&s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          final List<dynamic> results = data['Search'] ?? [];

          List<Movie> movies = [];
          for (var item in results) {
            if (item['Type'] == 'movie') {
              movies.add(Movie(
                id: item['imdbID'].hashCode,
                title: item['Title'] ?? '',
                overview: '', // La búsqueda no retorna plot
                posterPath: item['Poster'] ?? '',
                backdropPath: item['Poster'] ?? '',
                voteAverage: 0.0,
                releaseDate: item['Year'] ?? '',
                genreIds: [],
              ));
            }
          }

          return movies;
        }
      }

      return [];
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener detalles de película (por IMDb ID o título)
  Future<MovieDetail> getMovieDetails(int movieId,
      {String? imdbId, String? title}) async {
    try {
      String searchParam;

      if (imdbId != null) {
        searchParam = 'i=$imdbId';
      } else if (title != null) {
        searchParam = 't=$title';
      } else {
        // Si solo tenemos el ID, usamos títulos predefinidos
        final titles = [
          'Inception',
          'Her',
          'Interstellar',
          'The Dark Knight',
          'Parasite',
          'Joker',
        ];
        final index = movieId.abs() % titles.length;
        searchParam = 't=${titles[index]}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl?apikey=$apiKey&$searchParam&plot=full'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          return MovieDetail(
            id: movieId,
            title: data['Title'] ?? '',
            overview: data['Plot'] ?? '',
            posterPath: data['Poster'] ?? '',
            backdropPath: data['Poster'] ?? '',
            voteAverage: _parseRating(data['imdbRating']),
            releaseDate: data['Released'] ?? '',
            genres: _parseGenres(data['Genre']),
            runtime: _parseRuntime(data['Runtime']),
            status: 'Released',
          );
        }
      }

      throw Exception('Error al cargar detalles');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener créditos (OMDb tiene info limitada de actores)
  Future<Credits> getMovieCredits(int movieId,
      {String? imdbId, String? title}) async {
    try {
      String searchParam;

      if (imdbId != null) {
        searchParam = 'i=$imdbId';
      } else if (title != null) {
        searchParam = 't=$title';
      } else {
        final titles = [
          'Inception',
          'Her',
          'Interstellar',
          'The Dark Knight',
          'Parasite'
        ];
        final index = movieId.abs() % titles.length;
        searchParam = 't=${titles[index]}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl?apikey=$apiKey&$searchParam'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          // Parsear actores (OMDb solo da nombres, no fotos)
          List<Cast> cast = [];
          if (data['Actors'] != null && data['Actors'] != 'N/A') {
            final actors = data['Actors'].split(', ');
            for (var i = 0; i < actors.length; i++) {
              cast.add(Cast(
                id: i,
                name: actors[i],
                character: '', // OMDb no proporciona personaje
                profilePath: '', // OMDb no tiene fotos de actores
              ));
            }
          }

          // Parsear director
          List<Crew> crew = [];
          if (data['Director'] != null && data['Director'] != 'N/A') {
            crew.add(Crew(
              id: 0,
              name: data['Director'],
              job: 'Director',
              department: 'Directing',
            ));
          }

          return Credits(cast: cast, crew: crew);
        }
      }

      return Credits(cast: [], crew: []);
    } catch (e) {
      return Credits(cast: [], crew: []);
    }
  }

  // OMDb no tiene videos/trailers, retornar vacío
  Future<Videos> getMovieVideos(int movieId) async {
    // OMDb no proporciona trailers
    return Videos(results: []);
  }

  // Función auxiliar para parsear rating
  double _parseRating(dynamic rating) {
    if (rating == null || rating == 'N/A') return 0.0;
    try {
      return double.parse(rating.toString());
    } catch (e) {
      return 0.0;
    }
  }

  // Función auxiliar para parsear géneros
  List<Genre> _parseGenres(String? genreString) {
    if (genreString == null || genreString == 'N/A') return [];

    final genres = genreString.split(', ');
    return genres.asMap().entries.map((entry) {
      return Genre(id: entry.key, name: entry.value);
    }).toList();
  }

  // Función auxiliar para parsear duración
  int _parseRuntime(String? runtime) {
    if (runtime == null || runtime == 'N/A') return 0;

    try {
      // Runtime viene como "142 min"
      final minutes = runtime.replaceAll(' min', '');
      return int.parse(minutes);
    } catch (e) {
      return 0;
    }
  }

  // Alias para compatibilidad
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return getPopularMovies(page: page);
  }
}
