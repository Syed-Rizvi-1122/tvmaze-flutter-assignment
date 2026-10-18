import 'package:equatable/equatable.dart';

abstract class ShowsEvent extends Equatable {
  const ShowsEvent();
  @override
  List<Object?> get props => [];
}

class FetchShowsEvent extends ShowsEvent {
  const FetchShowsEvent();
}

class LoadMoreShowsEvent extends ShowsEvent {
  const LoadMoreShowsEvent();
}

class RefreshShowsEvent extends ShowsEvent {
  const RefreshShowsEvent();
}
