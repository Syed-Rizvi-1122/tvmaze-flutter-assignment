import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/watchlist_show.dart';
import '../data/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

/// App-level BLoC (mounted above MaterialApp) so watchlist state is shared
/// between the Watchlist tab and the Show Details screen.
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _repository;

  WatchlistBloc(this._repository) : super(const WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoad);
    on<ToggleWatchlistEvent>(_onToggle);
    on<ClearWatchlistEvent>(_onClear);
  }

  void _onLoad(LoadWatchlistEvent event, Emitter<WatchlistState> emit) {
    final items = _repository.loadWatchlist();
    emit(WatchlistLoaded(
      items: items,
      itemIds: items.map((s) => s.id).toSet(),
    ));
  }

  Future<void> _onToggle(
      ToggleWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final current = state;
    if (current is! WatchlistLoaded) return;

    List<WatchlistShow> updated;
    if (current.contains(event.show.id)) {
      updated = current.items.where((s) => s.id != event.show.id).toList();
    } else {
      updated = [event.show, ...current.items];
    }

    await _repository.saveWatchlist(updated);
    emit(current.copyWith(items: updated));
  }

  Future<void> _onClear(
      ClearWatchlistEvent event, Emitter<WatchlistState> emit) async {
    await _repository.saveWatchlist([]);
    emit(const WatchlistLoaded(items: [], itemIds: {}));
  }
}
