# 03: Live Debounced Search Feature

**What to build:** Build the end-to-end dynamic search screen allowing users to search TV shows by title with real-time feedback, a 500ms debounce preventing API spam, active "Shows" filter chip, clear text button, initial search guidance prompt, and custom "No results found" view.

**Blocked by:** 01: Core Infrastructure, Theme & Shell Foundation

**Status:** closed

- [x] Implement `SearchRemoteDataSource` and `SearchRepository` querying `https://api.tvmaze.com/search/shows?q={query}` and parsing results safely.
- [x] Implement `SearchBloc` with a 500ms debounce transformer on `SearchQueryChanged`, handling `SearchInitial`, `SearchLoading`, `SearchLoaded`, `SearchEmpty`, and `SearchError`.
- [x] Build `SearchScreen` featuring search text input with clear button, filter tabs ("Shows" active), responsive results list displaying poster thumbnail, title, years, genres, and rating.
- [x] Implement dedicated initial state view ("Search for your favorite shows") and zero-results state view ("No results found for '{query}'").
- [x] Add unit tests for `SearchBloc` verifying debouncing, empty query reset, and result transformations.
