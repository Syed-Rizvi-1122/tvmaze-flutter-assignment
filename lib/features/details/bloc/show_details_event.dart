import 'package:equatable/equatable.dart';

abstract class ShowDetailsEvent extends Equatable {
  const ShowDetailsEvent();
  @override
  List<Object?> get props => [];
}

class FetchShowDetailsEvent extends ShowDetailsEvent {
  final int showId;
  const FetchShowDetailsEvent(this.showId);

  @override
  List<Object?> get props => [showId];
}
