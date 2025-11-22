import 'package:equatable/equatable.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/genre_model.dart';
import '../../data/models/cast_model.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class NowPlayingMoviesLoaded extends MoviesState {
  final List<Movie> movies;

  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class GenresLoaded extends MoviesState {
  final List<Genre> genres;

  const GenresLoaded(this.genres);

  @override
  List<Object?> get props => [genres];
}

class MoviesByGenreLoaded extends MoviesState {
  final List<Movie> movies;
  final int genreId;

  const MoviesByGenreLoaded({required this.movies, required this.genreId});

  @override
  List<Object?> get props => [movies, genreId];
}

class MovieDetailsLoaded extends MoviesState {
  final Movie movie;
  final List<Cast> cast;
  final List<String> images;
  final List<Movie> similarMovies;

  const MovieDetailsLoaded({
    required this.movie,
    required this.cast,
    required this.images,
    required this.similarMovies,
  });

  @override
  List<Object?> get props => [movie, cast, images, similarMovies];
}

class MoviesSearchResults extends MoviesState {
  final List<Movie> movies;
  final String query;

  const MoviesSearchResults({required this.movies, required this.query});

  @override
  List<Object?> get props => [movies, query];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
