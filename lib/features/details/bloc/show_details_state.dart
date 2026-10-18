import 'package:equatable/equatable.dart';

import '../../shows/data/models/show.dart';
import '../data/models/cast_member.dart';
import '../data/models/episode.dart';

abstract class ShowDetailsState extends Equatable {
  const ShowDetailsState();
  @override
  List<Object?> get props => [];
}

class ShowDetailsInitial extends ShowDetailsState {
  const ShowDetailsInitial();
}

class ShowDetailsLoading extends ShowDetailsState {
  const ShowDetailsLoading();
}

class ShowDetailsLoaded extends ShowDetailsState {
  final Show show;
  final Map<int, List<Episode>> episodesBySeason;
  final List<CastMember> cast;

  const ShowDetailsLoaded({
    required this.show,
    required this.episodesBySeason,
    required this.cast,
  });

  @override
  List<Object?> get props => [show, episodesBySeason, cast];
}

class ShowDetailsError extends ShowDetailsState {
  final String message;
  const ShowDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
