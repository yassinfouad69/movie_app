import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNowPlayingMovies extends MoviesEvent {}

class LoadGenres extends MoviesEvent {}

class LoadMoviesByGenre extends MoviesEvent {
  final int genreId;
  final int page;

  const LoadMoviesByGenre({required this.genreId, this.page = 1});

  @override
  List<Object?> get props => [genreId, page];
}

class LoadMovieDetails extends MoviesEvent {
  final int movieId;

  const LoadMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class SearchMovies extends MoviesEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends MoviesEvent {}
