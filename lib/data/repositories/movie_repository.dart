import '../datasources/movie_api_service.dart';
import '../datasources/local_storage_service.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import '../models/cast_model.dart';

class MovieRepository {
  final MovieApiService _apiService;
  final LocalStorageService _localStorageService;

  final Map<int, Movie> _movieCache = {};
  final Map<int, List<Cast>> _castCache = {};
  final Map<int, List<Movie>> _similarMoviesCache = {};
  List<Genre>? _genresCache;
  List<Movie>? _nowPlayingCache;
  DateTime? _nowPlayingCacheTime;

  static const _cacheDuration = Duration(minutes: 5);

  MovieRepository(this._apiService, this._localStorageService);

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    if (page == 1 && _nowPlayingCache != null && _nowPlayingCacheTime != null) {
      if (DateTime.now().difference(_nowPlayingCacheTime!) < _cacheDuration) {
        return _nowPlayingCache!;
      }
    }

    final movies = await _apiService.getNowPlayingMovies(page: page);

    if (page == 1) {
      _nowPlayingCache = movies;
      _nowPlayingCacheTime = DateTime.now();
    }

    return movies;
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    return await _apiService.getMoviesByGenre(genreId, page: page);
  }

  Future<List<Genre>> getGenres() async {
    if (_genresCache != null) {
      return _genresCache!;
    }

    final genres = await _apiService.getGenres();
    _genresCache = genres;
    return genres;
  }

  Future<Movie> getMovieDetails(int movieId) async {
    await _localStorageService.addToHistory(movieId);

    if (_movieCache.containsKey(movieId)) {
      return _movieCache[movieId]!;
    }

    final movie = await _apiService.getMovieDetails(movieId);
    _movieCache[movieId] = movie;
    return movie;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (_castCache.containsKey(movieId)) {
      return _castCache[movieId]!;
    }

    final cast = await _apiService.getMovieCast(movieId);
    _castCache[movieId] = cast;
    return cast;
  }

  Future<List<String>> getMovieImages(int movieId) async {
    return await _apiService.getMovieImages(movieId);
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    if (_similarMoviesCache.containsKey(movieId)) {
      return _similarMoviesCache[movieId]!;
    }

    final movies = await _apiService.getSimilarMovies(movieId);
    _similarMoviesCache[movieId] = movies;
    return movies;
  }

  void clearCache() {
    _movieCache.clear();
    _castCache.clear();
    _similarMoviesCache.clear();
    _genresCache = null;
    _nowPlayingCache = null;
    _nowPlayingCacheTime = null;
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

    final futures = user.watchlist.map((movieId) async {
      try {
        return await _apiService.getMovieDetails(movieId);
      } catch (e) {
        return null;
      }
    }).toList();

    final results = await Future.wait(futures);
    return results.whereType<Movie>().toList();
  }

  Future<List<Movie>> getHistoryMovies() async {
    final user = _localStorageService.getUser();
    if (user == null) return [];

    final recentHistory = user.history.take(20).toList();
    final futures = recentHistory.map((movieId) async {
      try {
        return await _apiService.getMovieDetails(movieId);
      } catch (e) {
        return null;
      }
    }).toList();

    final results = await Future.wait(futures);
    return results.whereType<Movie>().toList();
  }
}
