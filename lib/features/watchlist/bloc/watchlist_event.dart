import 'package:equatable/equatable.dart';
import '../data/models/watchlist_show.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {
  const LoadWatchlistEvent();
}

class ToggleWatchlistEvent extends WatchlistEvent {
  final WatchlistShow show;
  const ToggleWatchlistEvent(this.show);

  @override
  List<Object?> get props => [show];
}

class ClearWatchlistEvent extends WatchlistEvent {
  const ClearWatchlistEvent();
}
