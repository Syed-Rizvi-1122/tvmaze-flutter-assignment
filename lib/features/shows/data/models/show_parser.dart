import 'show.dart';

/// Parses a single TVMaze show JSON map into a [Show].
Show showFromJson(Map<String, dynamic> json) {
  final image = json['image'] as Map<String, dynamic>?;
  final ratingMap = json['rating'] as Map<String, dynamic>?;
  final networkMap = json['network'] as Map<String, dynamic>?;

  return Show(
    id: json['id'] as int,
    name: json['name'] as String? ?? 'Unknown',
    posterUrl: image?['medium'] as String?,
    backdropUrl: image?['original'] as String?,
    genres: (json['genres'] as List<dynamic>?)
            ?.map((g) => g as String)
            .toList() ??
        [],
    rating: (ratingMap?['average'] as num?)?.toDouble(),
    summary: json['summary'] as String?,
    status: json['status'] as String?,
    premiered: json['premiered'] as String?,
    ended: json['ended'] as String?,
    network: networkMap?['name'] as String?,
    language: json['language'] as String?,
  );
}

/// Parses a list of show JSON objects from `/shows?page=X`.
List<Show> showsPageFromJson(List<dynamic> json) =>
    json.map((e) => showFromJson(e as Map<String, dynamic>)).toList();

/// Parses a search result list from `/search/shows?q=`.
/// Each item is `{"score": ..., "show": {...}}`.
List<Show> searchResultsFromJson(List<dynamic> json) => json
    .map((e) => showFromJson((e as Map<String, dynamic>)['show']
        as Map<String, dynamic>))
    .toList();
