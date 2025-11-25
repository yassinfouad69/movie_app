import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/cast_model.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MovieRepository _movieRepository;

  MoviesBloc(this._movieRepository) : super(MoviesInitial()) {
    on<LoadNowPlayingMovies>(_onLoadNowPlayingMovies);
    on<LoadGenres>(_onLoadGenres);
    on<LoadMoviesByGenre>(_onLoadMoviesByGenre);
    on<LoadMovieDetails>(_onLoadMovieDetails);
    on<SearchMovies>(_onSearchMovies);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadNowPlayingMovies(
    LoadNowPlayingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await _movieRepository.getNowPlayingMovies();
      emit(NowPlayingMoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onLoadGenres(
    LoadGenres event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final genres = await _movieRepository.getGenres();
      emit(GenresLoaded(genres));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onLoadMoviesByGenre(
    LoadMoviesByGenre event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await _movieRepository.getMoviesByGenre(
        event.genreId,
        page: event.page,
      );
      emit(MoviesByGenreLoaded(movies: movies, genreId: event.genreId));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final results = await Future.wait([
        _movieRepository.getMovieDetails(event.movieId),
        _movieRepository.getMovieCast(event.movieId),
        _movieRepository.getMovieImages(event.movieId),
        _movieRepository.getSimilarMovies(event.movieId),
      ]);

      emit(MovieDetailsLoaded(
        movie: results[0] as Movie,
        cast: results[1] as List<Cast>,
        images: results[2] as List<String>,
        similarMovies: results[3] as List<Movie>,
      ));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(MoviesInitial());
      return;
    }

    emit(MoviesLoading());
    try {
      final movies = await _movieRepository.searchMovies(event.query);
      emit(MoviesSearchResults(movies: movies, query: event.query));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesInitial());
  }
}
