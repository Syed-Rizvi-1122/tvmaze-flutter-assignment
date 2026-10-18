import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/show.dart';
import '../models/show_parser.dart';

/// Fetches show list pages from the TVMaze API.
class ShowsRemoteDataSource {
  final ApiClient _api;

  ShowsRemoteDataSource(this._api);

  /// Returns up to 250 shows for the given [page] (0-indexed).
  /// Throws [NotFoundException] when the page limit is reached.
  Future<List<Show>> fetchShows(int page) async {
    final data = await _api.get(showsEndpoint(page));
    return showsPageFromJson(data as List<dynamic>);
  }
}
