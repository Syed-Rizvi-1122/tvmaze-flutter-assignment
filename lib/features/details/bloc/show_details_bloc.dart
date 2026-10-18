import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/details_repository.dart';
import 'show_details_event.dart';
import 'show_details_state.dart';

class ShowDetailsBloc extends Bloc<ShowDetailsEvent, ShowDetailsState> {
  final DetailsRepository _repository;

  ShowDetailsBloc(this._repository) : super(const ShowDetailsInitial()) {
    on<FetchShowDetailsEvent>(_onFetch);
  }

  Future<void> _onFetch(
      FetchShowDetailsEvent event, Emitter<ShowDetailsState> emit) async {
    emit(const ShowDetailsLoading());
    try {
      // All three endpoints are fetched concurrently (ADR decision).
      final results = await Future.wait([
        _repository.getShow(event.showId),
        _repository.getCast(event.showId),
        _repository.getEpisodesBySeason(event.showId),
      ]);

      emit(ShowDetailsLoaded(
        show: results[0] as dynamic,
        cast: results[1] as dynamic,
        episodesBySeason: results[2] as dynamic,
      ));
    } catch (e) {
      emit(ShowDetailsError(e.toString()));
    }
  }
}
