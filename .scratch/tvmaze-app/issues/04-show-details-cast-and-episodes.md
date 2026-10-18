# 04: Show Details with Cast & Grouped Episodes

**What to build:** Build the comprehensive Show Details screen accessible by tapping any show card. It loads show metadata, cast members (`/shows/{id}/cast`), and episodes (`/shows/{id}/episodes`) concurrently via `Future.wait`, presenting an Overview tab with sanitized synopsis, an Episodes tab grouping episodes by season with an interactive season selector, and a Cast tab displaying actors and their characters.

**Blocked by:** 02: Discover & Home Feed with Pagination

**Status:** closed

- [x] Create `EpisodeModel` and `CastModel` parsing TVMaze API structures safely.
- [x] Implement `DetailsRemoteDataSource` and `DetailsRepository` fetching details, cast, and episodes concurrently in parallel, grouping episodes into `Map<int, List<EpisodeModel>>` keyed by season number.
- [x] Implement `ShowDetailsBloc` with events (`FetchShowDetails`, `SelectSeason`) and states (`ShowDetailsInitial`, `ShowDetailsLoading`, `ShowDetailsLoaded`, `ShowDetailsError`).
- [x] Build `ShowDetailsScreen` with backdrop banner, quick info chips (rating, years, status, network), segmented tabs (Overview, Episodes, Cast), and "+ Add to Watchlist" action button.
- [x] Build the Episodes tab with season dropdown picker ("Season X (N episodes)") and episode list tiles (thumbnail, number badge, title, airdate).
- [x] Build the Cast tab displaying avatar photo, actor name, and character name.
- [x] Add unit tests for `ShowDetailsBloc` verifying concurrent data combination and season grouping logic.
