import 'package:equatable/equatable.dart';
import '../../data/models/movie_model.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> movies;

  const WatchlistLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class HistoryLoaded extends WatchlistState {
  final List<Movie> movies;

  const HistoryLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class WatchlistUpdated extends WatchlistState {
  final bool isInWatchlist;

  const WatchlistUpdated(this.isInWatchlist);

  @override
  List<Object?> get props => [isInWatchlist];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
