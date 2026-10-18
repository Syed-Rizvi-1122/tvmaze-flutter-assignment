# Spec: TVMaze Explorer Application

Status: ready-for-agent

## Problem Statement

TV show enthusiasts need a seamless and visually compelling mobile application to discover popular television shows, search for specific titles dynamically, explore in-depth show details including cast and seasonal episodes, and maintain an offline-accessible personal watchlist. Furthermore, as an academic assignment, the codebase must demonstrate strict architectural discipline using the BLoC (Business Logic Component) pattern, separating UI widgets entirely from API calls, avoiding hardcoded data, and handling network loading and error states gracefully.

## Solution

A production-quality Flutter application following feature-first Clean Architecture and `flutter_bloc` state management. The app communicates with the public TVMaze REST API to power a dynamic Home feed with synthesized trending shows and paginated popular shows, provides a debounced live search with dedicated empty/error states, presents detailed show overviews with episode listings grouped by season and cast rosters, and stores a personal watchlist locally using `SharedPreferences`. The app features a premium dark cyberpunk/violet aesthetic matching reference mockups, with comprehensive documentation and viva preparation notes.

## User Stories

1. As a TV viewer, I want to see a curated carousel of trending shows when I open the app, so that I can immediately discover highly-rated content.
2. As a TV viewer, I want to scroll through a paginated feed of popular shows, so that I can browse a vast catalog without suffering long initial load times.
3. As a TV viewer, I want to see shimmering placeholder cards while shows are loading, so that the app feels fast and visually stable.
4. As a TV viewer, I want to see clear error screens with a retry button when network calls fail, so that I can easily recover from connection dropouts.
5. As a TV viewer, I want to search for TV shows by title with real-time feedback, so that I can quickly locate specific series.
6. As a TV viewer, I want the search input to wait until I pause typing before making an API call, so that unnecessary requests are avoided and the search remains responsive.
7. As a TV viewer, I want to see a clear "No results found" view when my search query yields no matches, so that I know my search executed but found no matching records.
8. As a TV viewer, I want to clear my search input with a single tap, so that I can reset my search state quickly.
9. As a TV viewer, I want to tap on any show card to navigate to its detailed overview, so that I can inspect its complete synopsis, rating, genres, and network information.
10. As a TV viewer, I want show synopses to display with clean formatting without raw HTML markup, so that reading summaries is pleasant and legible.
11. As a TV viewer, I want to switch between Overview, Episodes, and Cast tabs on the details screen, so that I can explore different aspects of the show in an organized layout.
12. As a TV viewer, I want to view episodes grouped by season and select different seasons from a dropdown, so that I can easily browse specific episodes.
13. As a TV viewer, I want to see the title, airdate, episode number, and thumbnail for each episode, so that I know exactly which installment I am viewing.
14. As a TV viewer, I want to see the cast members and the characters they portray with photos, so that I can identify the actors in the show.
15. As a TV viewer, I want to add or remove any show to my personal watchlist from the details screen, so that I can track shows I plan to watch.
16. As a TV viewer, I want to toggle a show's watchlist status directly from the watchlist screen, so that I can manage my saved shows conveniently.
17. As a TV viewer, I want my watchlist to persist even when I close and restart the application, so that my saved list is always retained on my device.
18. As a TV viewer, I want to see an inviting empty state on my watchlist with an "Explore Shows" button when no shows are saved, so that I am guided back to discover new shows.
19. As a TV viewer, I want to switch between Home, Search, Watchlist, and Profile tabs via a persistent bottom navigation bar without losing my scroll position, so that navigation is seamless.
20. As a student/examiner, I want all state changes to flow through explicit BLoC events and states, so that business logic is completely decoupled from UI widgets and easily defensible during viva.
21. As a student/examiner, I want comprehensive architecture documentation and viva notes in the README, so that the rationale for BLoC transitions and design patterns is completely transparent.

## Implementation Decisions

### Architectural Seams & Modules
- **Core Layer**: Encapsulates cross-cutting infrastructure including the HTTP client wrapper, custom failure and exception classes, theme tokens, debouncer utilities, HTML sanitization, and shared UI primitives (error views, shimmer loaders, cached image widgets).
- **Shows Module**: Contains the remote data source querying `/shows?page={page}`, repository extracting top ratings for "Trending Now" and passing paginated results to "Popular Shows", the `ShowsBloc` managing pagination state, and presentation widgets.
- **Search Module**: Encapsulates query debouncing (500ms), remote search calling `/search/shows?q={query}`, `SearchBloc` handling four states (Initial, Loading, Loaded, Empty), and search presentation screens.
- **Show Details Module**: Encapsulates concurrent fetching of `/shows/{id}`, `/shows/{id}/cast`, and `/shows/{id}/episodes` via `Future.wait`, transforming episodes into a `Map<int, List<Episode>>` grouped by season, and managing the tabbed details presentation.
- **Watchlist Module**: Encapsulates local persistence via `SharedPreferences` storing JSON-serialized `WatchlistShowModel` records under `'watchlist_shows_v1'`, with an app-level `WatchlistBloc` mounted at `MultiBlocProvider` above `MaterialApp` to guarantee live sync across screens.
- **Profile Module**: Encapsulates an About, Settings, and Viva information screen showing app metrics, TVMaze attribution, and BLoC architectural notes.

### Technical Clarifications & Contracts
- Respects ADR-0001 by synthesizing the "Trending Now" carousel client-side from the highest-rated shows of page 0.
- Respects ADR-0002 by coordinating watchlist state through a root-level `WatchlistBloc`.
- Respects ADR-0003 by restricting show details to the three native TVMaze endpoints (Overview, Episodes, Cast).
- State comparisons utilize `equatable` without code-generation build steps.
- Raw HTML in show summaries is sanitized to remove tags while retaining paragraph structure.

## Testing Decisions

- **Good Test Philosophy**: Tests exercise external module behavior across explicit seams, verifying outputs given inputs and state emissions given events, rather than testing private methods or widget layout coordinates.
- **BLoC Unit Tests**: Each BLoC (`ShowsBloc`, `SearchBloc`, `ShowDetailsBloc`, `WatchlistBloc`) will be tested using `bloc_test` and mocked repositories to verify state streams (`Loading` ➔ `Loaded`, `Error`, `Empty`).
- **Data Source & Repository Tests**: Repositories will be tested against mock API clients and local data sources to verify error mappings and data transformations (such as season grouping).
- **Prior Art**: Standard Flutter `test` and `bloc_test` patterns.

## Out of Scope

- User authentication, login accounts, and cloud syncing (watchlist is strictly local per assignment requirements).
- Video streaming or playback (TVMaze is a metadata catalog, not a streaming host).
- Similar shows tab (unsupported by TVMaze API; excluded per ADR-0003 to prevent hardcoded data).
- Search for people/actors (search is dedicated strictly to TV shows).

## Further Notes

- The UI theme faithfully adheres to the dark cyberpunk/violet design system (background `#0F1016`, accent `#8B5CF6`, surface `#161822`).
- A comprehensive `README.md` will include setup commands, application screenshots, and a structured Viva Preparation Guide.
