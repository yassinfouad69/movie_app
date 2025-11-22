import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/movie_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final MovieRepository _movieRepository;

  WatchlistBloc(this._movieRepository) : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<LoadHistory>(_onLoadHistory);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<ToggleWatchlist>(_onToggleWatchlist);
    on<CheckWatchlistStatus>(_onCheckWatchlistStatus);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoading());
    try {
      final movies = await _movieRepository.getWatchlistMovies();
      emit(WatchlistLoaded(movies));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoading());
    try {
      final movies = await _movieRepository.getHistoryMovies();
      emit(HistoryLoaded(movies));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await _movieRepository.addToWatchlist(event.movieId);
      emit(const WatchlistUpdated(true));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await _movieRepository.removeFromWatchlist(event.movieId);
      emit(const WatchlistUpdated(false));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      final isInWatchlist = _movieRepository.isInWatchlist(event.movieId);
      if (isInWatchlist) {
        await _movieRepository.removeFromWatchlist(event.movieId);
        emit(const WatchlistUpdated(false));
      } else {
        await _movieRepository.addToWatchlist(event.movieId);
        emit(const WatchlistUpdated(true));
      }
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onCheckWatchlistStatus(
    CheckWatchlistStatus event,
    Emitter<WatchlistState> emit,
  ) async {
    final isInWatchlist = _movieRepository.isInWatchlist(event.movieId);
    emit(WatchlistUpdated(isInWatchlist));
  }
}
