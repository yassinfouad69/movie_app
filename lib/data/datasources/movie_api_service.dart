import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import '../models/cast_model.dart';

class MovieApiService {
  final Dio _dio;

  MovieApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.ytsBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/list_movies.json',
        queryParameters: {
          'limit': 20,
          'page': page,
          'sort_by': 'date_added',
          'order_by': 'desc',
        },
      );
      final results = response.data['data']['movies'] as List?;
      if (results == null) return [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } catch (e) {
      throw Exception('Failed to fetch now playing movies: $e');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      // Map genre ID to genre name for YTS API
      final genreName = _getGenreNameById(genreId);

      final response = await _dio.get(
        '/list_movies.json',
        queryParameters: {
          'limit': 20,
          'page': page,
          'genre': genreName,
          'sort_by': 'rating',
          'order_by': 'desc',
        },
      );
      final results = response.data['data']['movies'] as List?;
      if (results == null) return [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies by genre: $e');
    }
  }

  String _getGenreNameById(int id) {
    final genres = {
      0: 'Action',
      1: 'Adventure',
      2: 'Animation',
      3: 'Comedy',
      4: 'Crime',
      5: 'Documentary',
      6: 'Drama',
      7: 'Family',
      8: 'Fantasy',
      9: 'History',
      10: 'Horror',
      11: 'Music',
      12: 'Mystery',
      13: 'Romance',
      14: 'Sci-Fi',
      15: 'Thriller',
      16: 'War',
      17: 'Western',
    };
    return genres[id] ?? 'Action';
  }

  Future<List<Genre>> getGenres() async {
    try {
      // YTS doesn't have a genres endpoint, return static list
      return [
        const Genre(id: 0, name: 'Action'),
        const Genre(id: 1, name: 'Adventure'),
        const Genre(id: 2, name: 'Animation'),
        const Genre(id: 3, name: 'Comedy'),
        const Genre(id: 4, name: 'Crime'),
        const Genre(id: 5, name: 'Documentary'),
        const Genre(id: 6, name: 'Drama'),
        const Genre(id: 7, name: 'Family'),
        const Genre(id: 8, name: 'Fantasy'),
        const Genre(id: 9, name: 'History'),
        const Genre(id: 10, name: 'Horror'),
        const Genre(id: 11, name: 'Music'),
        const Genre(id: 12, name: 'Mystery'),
        const Genre(id: 13, name: 'Romance'),
        const Genre(id: 14, name: 'Sci-Fi'),
        const Genre(id: 15, name: 'Thriller'),
        const Genre(id: 16, name: 'War'),
        const Genre(id: 17, name: 'Western'),
      ];
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true,
        },
      );
      return Movie.fromJson(response.data['data']['movie']);
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_cast': true,
        },
      );
      final cast = response.data['data']['movie']['cast'] as List?;
      if (cast == null || cast.isEmpty) return [];

      // YTS cast structure is different, map it to Cast model
      return cast.map((actor) {
        return Cast(
          id: 0, // YTS doesn't provide cast IDs
          name: actor['name'] ?? '',
          character: actor['character_name'],
          profilePath: actor['url_small_image'],
        );
      }).take(10).toList();
    } catch (e) {
      throw Exception('Failed to fetch movie cast: $e');
    }
  }

  Future<List<String>> getMovieImages(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
        },
      );

      final movie = response.data['data']['movie'];
      final List<String> images = [];

      // Add background images
      if (movie['background_image'] != null) {
        images.add(movie['background_image']);
      }
      if (movie['background_image_original'] != null) {
        images.add(movie['background_image_original']);
      }

      // Add cover images
      if (movie['large_cover_image'] != null) {
        images.add(movie['large_cover_image']);
      }

      return images.take(5).toList();
    } catch (e) {
      throw Exception('Failed to fetch movie images: $e');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie_suggestions.json',
        queryParameters: {'movie_id': movieId},
      );
      final results = response.data['data']['movies'] as List?;
      if (results == null) return [];
      return results.map((movie) => Movie.fromJson(movie)).take(10).toList();
    } catch (e) {
      throw Exception('Failed to fetch similar movies: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/list_movies.json',
        queryParameters: {
          'query_term': query,
          'limit': 20,
          'page': page,
        },
      );
      final results = response.data['data']['movies'] as List?;
      if (results == null) return [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}
