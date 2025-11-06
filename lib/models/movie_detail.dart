class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<Genre> genres;
  final int runtime;
  final String status;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
    required this.status,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres:
          (json['genres'] as List?)?.map((g) => Genre.fromJson(g)).toList() ??
              [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  String get fullPosterPath {
    if (posterPath.isEmpty || posterPath == 'N/A') return '';
    if (posterPath.startsWith('http')) return posterPath;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath.isEmpty || backdropPath == 'N/A') return '';
    if (backdropPath.startsWith('http')) return backdropPath;
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  String get formattedRuntime {
    if (runtime == 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}min';
  }

  String get year {
    if (releaseDate.isEmpty) return 'N/A';
    return releaseDate.split('-')[0];
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
