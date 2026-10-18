# App-Level Watchlist State Coordination

The Watchlist can be modified from both the Show Details screen (via Add/Remove button) and the Watchlist screen itself. We decided to provide `WatchlistBloc` at the application root (`MultiBlocProvider` above `MaterialApp`) rather than scoping it locally to the Watchlist tab. This guarantees that any changes made on the Show Details screen immediately propagate across the widget tree and persist to local storage without requiring manual reload events or navigation callbacks.
