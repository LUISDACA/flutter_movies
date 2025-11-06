// Reemplaza con tu API Key de OMDb
//  static const String apiKey = '6f5fdf8f';
//  static const String youtubeApiKey = 'AIzaSyCcUZyrdNCdybhrVj0h0SfovnhU53qoUQk';
//  static const String baseUrl = 'http://www.omdbapi.com/';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/cast.dart';
import '../models/video.dart';

/// Servicio OMDb mejorado con YouTube (trailers) y Fanart.tv (imágenes)
class OMDbService {
  // OMDb API - Datos principales
  static const String omdbApiKey = '6f5fdf8f';
  static const String omdbBaseUrl = 'http://www.omdbapi.com/';

  // YouTube Data API v3 - Para trailers
  static const String youtubeApiKey = 'AIzaSyCcUZyrdNCdybhrVj0h0SfovnhU53qoUQk';
  static const String youtubeBaseUrl = 'https://www.googleapis.com/youtube/v3';

  // Obtener películas populares
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
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

  Future<Movie?> _searchSingleMovie(String title) async {
    try {
      final response = await http.get(
        Uri.parse('$omdbBaseUrl?apikey=$omdbApiKey&t=$title'),
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

  // Buscar películas
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$omdbBaseUrl?apikey=$omdbApiKey&s=$query'),
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
                overview: '',
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

  // Obtener detalles de película
  Future<MovieDetail> getMovieDetails(int movieId,
      {String? imdbId, String? title}) async {
    try {
      String searchParam;

      if (imdbId != null) {
        searchParam = 'i=$imdbId';
      } else if (title != null) {
        searchParam = 't=$title';
      } else {
        final titles = ['Inception', 'Her', 'Interstellar'];
        final index = movieId.abs() % titles.length;
        searchParam = 't=${titles[index]}';
      }

      final response = await http.get(
        Uri.parse('$omdbBaseUrl?apikey=$omdbApiKey&$searchParam&plot=full'),
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

  // Obtener créditos (cast)
  Future<Credits> getMovieCredits(int movieId,
      {String? imdbId, String? title}) async {
    try {
      String searchParam;

      if (imdbId != null) {
        searchParam = 'i=$imdbId';
      } else if (title != null) {
        searchParam = 't=$title';
      } else {
        final titles = ['Inception', 'Her', 'Interstellar'];
        final index = movieId.abs() % titles.length;
        searchParam = 't=${titles[index]}';
      }

      final response = await http.get(
        Uri.parse('$omdbBaseUrl?apikey=$omdbApiKey&$searchParam'),
      );

      List<Cast> cast = [];
      List<Crew> crew = [];

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          // Parsear actores de OMDb (solo nombres)
          if (data['Actors'] != null && data['Actors'] != 'N/A') {
            final actors = data['Actors'].split(', ');
            for (var i = 0; i < actors.length; i++) {
              cast.add(Cast(
                id: i,
                name: actors[i],
                character: '',
                profilePath: '',
              ));
            }
          }

          // Director
          if (data['Director'] != null && data['Director'] != 'N/A') {
            crew.add(Crew(
              id: 0,
              name: data['Director'],
              job: 'Director',
              department: 'Directing',
            ));
          }
        }
      }

      return Credits(cast: cast, crew: crew);
    } catch (e) {
      return Credits(cast: [], crew: []);
    }
  }

  // Obtener trailers desde YouTube Data API
  Future<Videos> getMovieVideos(int movieId, {String? title}) async {
    // Si no hay YouTube API Key, retornar vacío
    if (youtubeApiKey == 'TU_API_KEY_YOUTUBE') {
      print('⚠️ YouTube API Key no configurada. Los trailers no funcionarán.');
      return Videos(results: []);
    }

    try {
      final searchTitle = title ?? 'Inception';
      final searchQuery = '$searchTitle official trailer';

      // Buscar en YouTube
      final response = await http.get(
        Uri.parse(
            '$youtubeBaseUrl/search?part=snippet&q=$searchQuery&type=video&maxResults=3&key=$youtubeApiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];

        List<Video> videos = [];
        for (var item in items) {
          videos.add(Video(
            id: item['id']['videoId'],
            key: item['id']['videoId'],
            name: item['snippet']['title'],
            site: 'YouTube',
            type: 'Trailer',
          ));
        }

        return Videos(results: videos);
      }

      return Videos(results: []);
    } catch (e) {
      print('Error obteniendo videos de YouTube: $e');
      return Videos(results: []);
    }
  }

  // Funciones auxiliares
  double _parseRating(dynamic rating) {
    if (rating == null || rating == 'N/A') return 0.0;
    try {
      return double.parse(rating.toString());
    } catch (e) {
      return 0.0;
    }
  }

  List<Genre> _parseGenres(String? genreString) {
    if (genreString == null || genreString == 'N/A') return [];

    final genres = genreString.split(', ');
    return genres.asMap().entries.map((entry) {
      return Genre(id: entry.key, name: entry.value);
    }).toList();
  }

  int _parseRuntime(String? runtime) {
    if (runtime == null || runtime == 'N/A') return 0;

    try {
      final minutes = runtime.replaceAll(' min', '');
      return int.parse(minutes);
    } catch (e) {
      return 0;
    }
  }

  // Alias
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return getPopularMovies(page: page);
  }
}
