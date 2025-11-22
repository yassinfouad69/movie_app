import '../datasources/movie_api_service.dart';
import '../datasources/local_storage_service.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import '../models/cast_model.dart';

class MovieRepository {
  final MovieApiService _apiService;
  final LocalStorageService _localStorageService;

  MovieRepository(this._apiService, this._localStorageService);

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return await _apiService.getNowPlayingMovies(page: page);
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    return await _apiService.getMoviesByGenre(genreId, page: page);
  }

  Future<List<Genre>> getGenres() async {
    return await _apiService.getGenres();
  }

  Future<Movie> getMovieDetails(int movieId) async {
    await _localStorageService.addToHistory(movieId);
    return await _apiService.getMovieDetails(movieId);
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    return await _apiService.getMovieCast(movieId);
  }

  Future<List<String>> getMovieImages(int movieId) async {
    return await _apiService.getMovieImages(movieId);
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    return await _apiService.getSimilarMovies(movieId);
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    return await _apiService.searchMovies(query, page: page);
  }

  Future<bool> addToWatchlist(int movieId) async {
    return await _localStorageService.addToWatchlist(movieId);
  }

  Future<bool> removeFromWatchlist(int movieId) async {
    return await _localStorageService.removeFromWatchlist(movieId);
  }

  bool isInWatchlist(int movieId) {
    return _localStorageService.isInWatchlist(movieId);
  }

  Future<List<Movie>> getWatchlistMovies() async {
    final user = _localStorageService.getUser();
    if (user == null) return [];

    final List<Movie> movies = [];
    for (final movieId in user.watchlist) {
      try {
        final movie = await _apiService.getMovieDetails(movieId);
        movies.add(movie);
      } catch (e) {
        continue;
      }
    }
    return movies;
  }

  Future<List<Movie>> getHistoryMovies() async {
    final user = _localStorageService.getUser();
    if (user == null) return [];

    final List<Movie> movies = [];
    for (final movieId in user.history) {
      try {
        final movie = await _apiService.getMovieDetails(movieId);
        movies.add(movie);
      } catch (e) {
        continue;
      }
    }
    return movies;
  }
}
