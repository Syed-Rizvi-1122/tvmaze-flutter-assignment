import '../../../shows/data/models/show.dart';
import '../datasources/details_remote_datasource.dart';
import '../models/cast_member.dart';
import '../models/episode.dart';

class DetailsRepository {
  final DetailsRemoteDataSource _dataSource;

  DetailsRepository(this._dataSource);

  Future<Show> getShow(int id) => _dataSource.fetchShow(id);

  Future<List<CastMember>> getCast(int id) => _dataSource.fetchCast(id);

  Future<Map<int, List<Episode>>> getEpisodesBySeason(int id) async {
    final episodes = await _dataSource.fetchEpisodes(id);
    return groupEpisodesBySeason(episodes);
  }

  /// Groups a flat episode list into a map keyed by season number.
  /// Season keys are sorted ascending.
  static Map<int, List<Episode>> groupEpisodesBySeason(List<Episode> episodes) {
    final map = <int, List<Episode>>{};
    for (final ep in episodes) {
      map.putIfAbsent(ep.season, () => []).add(ep);
    }
    // Sort episodes within each season by episode number.
    for (final list in map.values) {
      list.sort((a, b) => a.number.compareTo(b.number));
    }
    return Map.fromEntries(
        map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}
