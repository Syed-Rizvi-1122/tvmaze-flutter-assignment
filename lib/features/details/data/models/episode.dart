import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int id;
  final String name;
  final int season;
  final int number;
  final String? airdate;
  final String? imageUrl;
  final String? summary;
  final int? runtime;

  const Episode({
    required this.id,
    required this.name,
    required this.season,
    required this.number,
    this.airdate,
    this.imageUrl,
    this.summary,
    this.runtime,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    return Episode(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      season: json['season'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      airdate: json['airdate'] as String?,
      imageUrl: image?['medium'] as String?,
      summary: json['summary'] as String?,
      runtime: json['runtime'] as int?,
    );
  }

  @override
  List<Object?> get props => [id];
}
