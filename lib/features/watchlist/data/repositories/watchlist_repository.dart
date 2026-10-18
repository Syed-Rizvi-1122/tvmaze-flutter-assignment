import '../datasources/watchlist_local_datasource.dart';
import '../models/watchlist_show.dart';

class WatchlistRepository {
  final WatchlistLocalDataSource _dataSource;

  WatchlistRepository(this._dataSource);

  List<WatchlistShow> loadWatchlist() => _dataSource.loadWatchlist();

  Future<void> saveWatchlist(List<WatchlistShow> shows) =>
      _dataSource.saveWatchlist(shows);
}
