import 'package:equatable/equatable.dart';

class CastMember extends Equatable {
  final int personId;
  final String personName;
  final String? personImageUrl;
  final String characterName;

  const CastMember({
    required this.personId,
    required this.personName,
    this.personImageUrl,
    required this.characterName,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? {};
    final character = json['character'] as Map<String, dynamic>? ?? {};
    final image = person['image'] as Map<String, dynamic>?;
    return CastMember(
      personId: person['id'] as int? ?? 0,
      personName: person['name'] as String? ?? '',
      personImageUrl: image?['medium'] as String?,
      characterName: character['name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [personId];
}
