class Cast {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  String get fullProfilePath {
    if (profilePath.isEmpty || profilePath == 'N/A') return '';
    if (profilePath.startsWith('http')) return profilePath;
    return 'https://image.tmdb.org/t/p/w200$profilePath';
  }
}

class Crew {
  final int id;
  final String name;
  final String job;
  final String department;

  Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      department: json['department'] ?? '',
    );
  }
}

class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      cast:
          (json['cast'] as List?)?.map((c) => Cast.fromJson(c)).toList() ?? [],
      crew:
          (json['crew'] as List?)?.map((c) => Crew.fromJson(c)).toList() ?? [],
    );
  }

  String? get director {
    try {
      return crew.firstWhere((c) => c.job == 'Director').name;
    } catch (e) {
      return null;
    }
  }
}
