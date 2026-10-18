import 'package:equatable/equatable.dart';
import '../data/models/show.dart';

abstract class ShowsState extends Equatable {
  const ShowsState();
  @override
  List<Object?> get props => [];
}

class ShowsInitial extends ShowsState {
  const ShowsInitial();
}

class ShowsLoading extends ShowsState {
  const ShowsLoading();
}

class ShowsLoaded extends ShowsState {
  final List<Show> trending;
  final List<Show> popular;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ShowsLoaded({
    required this.trending,
    required this.popular,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ShowsLoaded copyWith({
    List<Show>? trending,
    List<Show>? popular,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ShowsLoaded(
      trending: trending ?? this.trending,
      popular: popular ?? this.popular,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [trending, popular, hasReachedMax, isLoadingMore];
}

class ShowsError extends ShowsState {
  final String message;
  const ShowsError(this.message);

  @override
  List<Object?> get props => [message];
}
