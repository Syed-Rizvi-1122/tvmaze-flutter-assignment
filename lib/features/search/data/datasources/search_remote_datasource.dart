import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../shows/data/models/show.dart';
import '../../../shows/data/models/show_parser.dart';

class SearchRemoteDataSource {
  final ApiClient _api;

  SearchRemoteDataSource(this._api);

  Future<List<Show>> searchShows(String query) async {
    final data = await _api.get(searchShowsEndpoint(query));
    return searchResultsFromJson(data as List<dynamic>);
  }
}
