# 05: Watchlist Local Persistence & Cross-Screen Sync

**What to build:** Build the personal Watchlist feature allowing users to add or remove shows from their local watchlist, persist saved items across app restarts using `SharedPreferences`, view saved shows in a dedicated tab with direct remove buttons, see an inviting empty state with an "Explore Shows" navigation button, and have live state synchronization between the Show Details screen and the Watchlist tab via an app-level `WatchlistBloc`.

**Blocked by:** 04: Show Details with Cast & Grouped Episodes

**Status:** closed

- [x] Create `WatchlistShowModel` representing the essential metadata needed for offline display.
- [x] Implement `WatchlistLocalDataSource` persisting and retrieving serialized JSON lists via `SharedPreferences` under `'watchlist_shows_v1'` with error handling.
- [x] Implement `WatchlistRepository` and app-level `WatchlistBloc` handling `LoadWatchlist`, `ToggleWatchlist`, and `ClearWatchlist` events.
- [x] Connect the Watchlist toggle button on `ShowDetailsScreen` (and heart icon in the app bar) with reactive visual state ("+ Add to Watchlist" vs "✓ In Watchlist").
- [x] Build `WatchlistScreen` displaying saved shows with poster, title, rating, genres, and remove button.
- [x] Build the empty watchlist view with custom purple glowing illustration, explanatory copy, and "Explore Shows" button navigating to the Home tab.
- [x] Add unit tests for `WatchlistBloc` and `WatchlistLocalDataSource` verifying add, remove, duplicate prevention, and persistence.
