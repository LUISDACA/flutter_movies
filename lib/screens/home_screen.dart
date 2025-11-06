import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../models/video.dart';
import '../services/omdb_service.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OMDbService _tmdbService = OMDbService();
  List<Movie> _movies = [];
  List<Video> _trailers = [];
  bool _isLoading = true;
  int _selectedDateIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Generar fechas para el selector
  List<Map<String, String>> _generateDates() {
    final now = DateTime.now();
    List<Map<String, String>> dates = [];

    for (int i = -1; i <= 3; i++) {
      final date = now.add(Duration(days: i));
      dates.add({
        'day': _getDayName(date.weekday),
        'date': date.day.toString(),
      });
    }

    return dates;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final movies = await _tmdbService.getNowPlayingMovies();

      // Cargar trailers de las primeras películas
      List<Video> allTrailers = [];
      for (var i = 0; i < (movies.length > 3 ? 3 : movies.length); i++) {
        try {
          final videos = await _tmdbService.getMovieVideos(
            movies[i].id,
            title: movies[i].title,
          );
          allTrailers.addAll(videos.trailers);
        } catch (e) {
          print('Error loading trailer: $e');
        }
      }

      setState(() {
        _movies = movies;
        _trailers = allTrailers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _searchMovies(value);
                          }
                        },
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Text(
                            'Top Movies',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Date selector
                    Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedDateIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateIndex = index;
                              });
                            },
                            child: Container(
                              width: 65,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE91E63)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dates[index]['day']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    dates[index]['date']!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Movies grid - TODAS LAS PELÍCULAS CON SCROLL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: _movies.length, // ← TODAS las películas
                        itemBuilder: (context, index) {
                          final movie = _movies[index];
                          return _buildMovieCard(movie);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Trailers section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Trailers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    // Trailers list
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _trailers.length,
                        itemBuilder: (context, index) {
                          final trailer = _trailers[index];
                          return _buildTrailerCard(trailer);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movieId: movie.id,
              movieTitle: movie.title,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: movie.fullPosterPath,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailerCard(Video trailer) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: trailer.youtubeThumbnail,
              fit: BoxFit.cover,
              width: 200,
              height: 120,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
            Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.9),
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchMovies(String query) async {
    try {
      final results = await _tmdbService.searchMovies(query);
      setState(() {
        _movies = results;
      });
    } catch (e) {
      print('Error searching: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
