import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/constants/app_constants.dart';
import '../data/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc(this._repository) : super(const SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(kSearchDebounce)
          .distinct()
          .switchMap(mapper),
    );
    on<ClearSearchEvent>(_onClear);
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    try {
      final results = await _repository.searchShows(query);
      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(shows: results, query: query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClear(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }
}
