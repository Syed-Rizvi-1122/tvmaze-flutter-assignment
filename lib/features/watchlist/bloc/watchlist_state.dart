import 'package:equatable/equatable.dart';
import '../data/models/watchlist_show.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();
  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistShow> items;

  /// Set of show IDs for O(1) membership check in UI.
  final Set<int> itemIds;

  const WatchlistLoaded({required this.items, required this.itemIds});

  bool contains(int showId) => itemIds.contains(showId);

  WatchlistLoaded copyWith({List<WatchlistShow>? items}) {
    final next = items ?? this.items;
    return WatchlistLoaded(
      items: next,
      itemIds: next.map((s) => s.id).toSet(),
    );
  }

  @override
  List<Object?> get props => [items, itemIds];
}
