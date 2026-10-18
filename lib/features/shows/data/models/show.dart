import 'package:equatable/equatable.dart';

/// Domain entity representing a TV show.
class Show extends Equatable {
  final int id;
  final String name;
  final String? posterUrl;
  final String? backdropUrl;
  final List<String> genres;
  final double? rating;
  final String? summary;
  final String? status;
  final String? premiered;
  final String? ended;
  final String? network;
  final String? language;

  const Show({
    required this.id,
    required this.name,
    this.posterUrl,
    this.backdropUrl,
    this.genres = const [],
    this.rating,
    this.summary,
    this.status,
    this.premiered,
    this.ended,
    this.network,
    this.language,
  });

  String get premieredYear => premiered?.substring(0, 4) ?? '';
  String get endedYear => ended?.substring(0, 4) ?? '';

  String get yearsLabel {
    if (premieredYear.isEmpty) return '';
    if (endedYear.isEmpty) return '$premieredYear - Present';
    if (premieredYear == endedYear) return premieredYear;
    return '$premieredYear - $endedYear';
  }

  @override
  List<Object?> get props => [id];
}
