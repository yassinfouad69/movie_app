import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {}

class LoadHistory extends WatchlistEvent {}

class AddToWatchlist extends WatchlistEvent {
  final int movieId;

  const AddToWatchlist(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final int movieId;

  const RemoveFromWatchlist(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class ToggleWatchlist extends WatchlistEvent {
  final int movieId;

  const ToggleWatchlist(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class CheckWatchlistStatus extends WatchlistEvent {
  final int movieId;

  const CheckWatchlistStatus(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
