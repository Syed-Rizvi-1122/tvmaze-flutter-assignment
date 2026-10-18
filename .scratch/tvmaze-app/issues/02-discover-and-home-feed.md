# 02: Discover & Home Feed with Pagination

**What to build:** Build the end-to-end Home / Discover screen featuring a synthesized "Trending Now" carousel of top-rated shows from page 0, an infinite-scrolling "Popular Shows" grid with page-by-page fetching (`/shows?page=X`), pull-to-refresh, shimmer placeholder cards, and error recovery views.

**Blocked by:** 01: Core Infrastructure, Theme & Shell Foundation

**Status:** closed

- [x] Create `ShowModel` in `lib/features/shows/data/models/` parsing JSON from the TVMaze API safely, with null fallbacks for images and ratings.
- [x] Implement `ShowsRemoteDataSource` and `ShowsRepository` fetching shows and synthesizing "Trending Now" (top 10 highest-rated shows from page 0) and paginated "Popular Shows".
- [x] Implement `ShowsBloc` with events (`FetchShows`, `LoadMoreShows`, `RefreshShows`) and states (`ShowsInitial`, `ShowsLoading`, `ShowsLoaded`, `ShowsError`) handling pagination boundaries (`hasReachedMax`).
- [x] Build `HomeScreen` with greeting header, "Trending Now" horizontal carousel, "Popular Shows" grid/list, infinite scroll listener, shimmer skeleton loading, and error retry view.
- [x] Add unit tests for `ShowsBloc` and `ShowsRepository` validating pagination logic and error handling.
