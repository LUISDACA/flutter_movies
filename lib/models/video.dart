class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
  String get youtubeThumbnail => 'https://img.youtube.com/vi/$key/hqdefault.jpg';
}

class Videos {
  final List<Video> results;

  Videos({required this.results});

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      results: (json['results'] as List?)
              ?.map((v) => Video.fromJson(v))
              .toList() ??
          [],
    );
  }

  List<Video> get trailers =>
      results.where((v) => v.type == 'Trailer' && v.site == 'YouTube').toList();
}
