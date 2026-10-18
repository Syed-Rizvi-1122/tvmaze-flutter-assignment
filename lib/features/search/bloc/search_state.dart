import 'package:equatable/equatable.dart';
import '../../shows/data/models/show.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

/// Initial state: no query entered yet.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Debounce window active or API call in flight.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// API returned results.
class SearchLoaded extends SearchState {
  final List<Show> shows;
  final String query;
  const SearchLoaded({required this.shows, required this.query});

  @override
  List<Object?> get props => [shows, query];
}

/// API returned empty list.
class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

/// API call failed.
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
