import 'package:equatable/equatable.dart';
import '../../../shows/data/models/show.dart';

/// Lightweight watchlist entry stored locally.
class WatchlistShow extends Equatable {
  final int id;
  final String name;
  final String? posterUrl;
  final double? rating;
  final List<String> genres;
  final String? premiered;
  final String? ended;
  final String? status;

  const WatchlistShow({
    required this.id,
    required this.name,
    this.posterUrl,
    this.rating,
    this.genres = const [],
    this.premiered,
    this.ended,
    this.status,
  });

  factory WatchlistShow.fromShow(Show show) => WatchlistShow(
        id: show.id,
        name: show.name,
        posterUrl: show.posterUrl,
        rating: show.rating,
        genres: show.genres,
        premiered: show.premiered,
        ended: show.ended,
        status: show.status,
      );

  factory WatchlistShow.fromJson(Map<String, dynamic> json) => WatchlistShow(
        id: json['id'] as int,
        name: json['name'] as String,
        posterUrl: json['posterUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        genres: (json['genres'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        premiered: json['premiered'] as String?,
        ended: json['ended'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'posterUrl': posterUrl,
        'rating': rating,
        'genres': genres,
        'premiered': premiered,
        'ended': ended,
        'status': status,
      };

  String get yearsLabel {
    final start = premiered?.substring(0, 4) ?? '';
    final end = ended?.substring(0, 4) ?? '';
    if (start.isEmpty) return '';
    if (end.isEmpty) return '$start - Present';
    return '$start - $end';
  }

  @override
  List<Object?> get props => [id];
}
