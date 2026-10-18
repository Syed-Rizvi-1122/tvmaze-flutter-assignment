import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/details/data/datasources/details_remote_datasource.dart';
import 'features/details/data/repositories/details_repository.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/search/data/datasources/search_remote_datasource.dart';
import 'features/search/data/repositories/search_repository.dart';
import 'features/search/presentation/screens/search_screen.dart';
import 'features/shell/main_navigation_shell.dart';
import 'features/shows/bloc/shows_bloc.dart';
import 'features/shows/bloc/shows_event.dart';
import 'features/shows/data/datasources/shows_remote_datasource.dart';
import 'features/shows/data/repositories/shows_repository.dart';
import 'features/shows/presentation/screens/home_screen.dart';
import 'features/watchlist/bloc/watchlist_bloc.dart';
import 'features/watchlist/bloc/watchlist_event.dart';
import 'features/watchlist/data/datasources/watchlist_local_datasource.dart';
import 'features/watchlist/data/repositories/watchlist_repository.dart';
import 'features/watchlist/presentation/screens/watchlist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final apiClient = ApiClient();
  final showsRepo = ShowsRepository(ShowsRemoteDataSource(apiClient));
  final searchRepo = SearchRepository(SearchRemoteDataSource(apiClient));
  final detailsRepo = DetailsRepository(DetailsRemoteDataSource(apiClient));
  final watchlistRepo = WatchlistRepository(WatchlistLocalDataSource(prefs));

  registerTabBodies(const [
    HomeScreen(),
    SearchScreen(),
    WatchlistScreen(),
    ProfileScreen(),
  ]);

  runApp(TVMazeApp(
    showsRepo: showsRepo,
    searchRepo: searchRepo,
    detailsRepo: detailsRepo,
    watchlistRepo: watchlistRepo,
  ));
}

class TVMazeApp extends StatelessWidget {
  final ShowsRepository showsRepo;
  final SearchRepository searchRepo;
  final DetailsRepository detailsRepo;
  final WatchlistRepository watchlistRepo;

  const TVMazeApp({
    super.key,
    required this.showsRepo,
    required this.searchRepo,
    required this.detailsRepo,
    required this.watchlistRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: showsRepo),
        RepositoryProvider.value(value: searchRepo),
        RepositoryProvider.value(value: detailsRepo),
        RepositoryProvider.value(value: watchlistRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => WatchlistBloc(watchlistRepo)..add(const LoadWatchlistEvent()),
          ),
          BlocProvider(
            create: (_) => ShowsBloc(showsRepo)..add(const FetchShowsEvent()),
          ),
          BlocProvider(
            create: (_) => SearchBloc(searchRepo),
          ),
        ],
        child: MaterialApp(
          title: 'TVMaze',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const MainNavigationShell(),
        ),
      ),
    );
  }
}
