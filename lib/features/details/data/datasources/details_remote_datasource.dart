import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../shows/data/models/show.dart';
import '../../../shows/data/models/show_parser.dart';
import '../models/cast_member.dart';
import '../models/episode.dart';

class DetailsRemoteDataSource {
  final ApiClient _api;

  DetailsRemoteDataSource(this._api);

  Future<Show> fetchShow(int id) async {
    final data = await _api.get(showDetailEndpoint(id));
    return showFromJson(data as Map<String, dynamic>);
  }

  Future<List<CastMember>> fetchCast(int id) async {
    final data = await _api.get(showCastEndpoint(id));
    return (data as List<dynamic>)
        .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Episode>> fetchEpisodes(int id) async {
    final data = await _api.get(showEpisodesEndpoint(id));
    return (data as List<dynamic>)
        .map((e) => Episode.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
