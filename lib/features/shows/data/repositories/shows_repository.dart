import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/shows_remote_datasource.dart';
import '../models/show.dart';

/// Coordinates show data access and synthesises the Trending Now list.
class ShowsRepository {
  final ShowsRemoteDataSource _dataSource;

  ShowsRepository(this._dataSource);

  /// Returns all shows from [page].
  ///
  /// Returns an empty list and sets [hasReachedMax] signal when [NotFoundException]
  /// is thrown (page beyond catalog end).
  Future<List<Show>> getShowsPage(int page) async {
    try {
      return await _dataSource.fetchShows(page);
    } on NotFoundException {
      return [];
    }
  }

  /// Extracts the top [kTrendingCount] shows by rating from [shows].
  List<Show> extractTrending(List<Show> shows) {
    final withRating = shows.where((s) => s.rating != null).toList()
      ..sort((a, b) => b.rating!.compareTo(a.rating!));
    return withRating.take(kTrendingCount).toList();
  }
}
