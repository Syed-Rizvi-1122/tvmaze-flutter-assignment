import '../../../shows/data/models/show.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepository {
  final SearchRemoteDataSource _dataSource;

  SearchRepository(this._dataSource);

  Future<List<Show>> searchShows(String query) =>
      _dataSource.searchShows(query);
}
