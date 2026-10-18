import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/shows_repository.dart';
import 'shows_event.dart';
import 'shows_state.dart';

class ShowsBloc extends Bloc<ShowsEvent, ShowsState> {
  final ShowsRepository _repository;
  int _currentPage = 0;

  ShowsBloc(this._repository) : super(const ShowsInitial()) {
    on<FetchShowsEvent>(_onFetch);
    on<LoadMoreShowsEvent>(_onLoadMore);
    on<RefreshShowsEvent>(_onRefresh);
  }

  Future<void> _onFetch(FetchShowsEvent event, Emitter<ShowsState> emit) async {
    emit(const ShowsLoading());
    try {
      _currentPage = 0;
      final shows = await _repository.getShowsPage(_currentPage);
      if (shows.isEmpty) {
        emit(const ShowsLoaded(trending: [], popular: [], hasReachedMax: true));
        return;
      }
      final trending = _repository.extractTrending(shows);
      emit(ShowsLoaded(trending: trending, popular: shows));
    } catch (e) {
      emit(ShowsError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreShowsEvent event, Emitter<ShowsState> emit) async {
    final current = state;
    if (current is! ShowsLoaded || current.hasReachedMax || current.isLoadingMore) {
      return;
    }
    emit(current.copyWith(isLoadingMore: true));
    try {
      _currentPage++;
      final newShows = await _repository.getShowsPage(_currentPage);
      if (newShows.isEmpty) {
        emit(current.copyWith(hasReachedMax: true, isLoadingMore: false));
      } else {
        emit(current.copyWith(
          popular: [...current.popular, ...newShows],
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      _currentPage--;
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
      RefreshShowsEvent event, Emitter<ShowsState> emit) async {
    add(const FetchShowsEvent());
  }
}
