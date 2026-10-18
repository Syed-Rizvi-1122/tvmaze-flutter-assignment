# 06: Profile Screen, Viva Documentation & Project Polish

**What to build:** Build the 4th tab "Profile / About" screen presenting app information, live watchlist metrics, TVMaze API attribution, and student viva credentials. Create comprehensive `README.md` documentation including setup instructions, application screenshots, architectural diagrams, BLoC unidirectional flow explanations, and answers to anticipated viva evaluation questions. Complete end-to-end lint, test, and runtime validation.

**Blocked by:** 03: Live Debounced Search Feature, 05: Watchlist Local Persistence & Cross-Screen Sync

**Status:** closed

- [x] Implement `ProfileScreen` in `lib/features/profile/presentation/` displaying student viva credentials, watchlist statistics, TVMaze API attribution links, and project version.
- [x] Write a comprehensive, professionally styled `README.md` with:
  - Setup instructions (`flutter pub get`, `flutter run`).
  - Architecture breakdown (Feature-First Clean Architecture, BLoC pattern, Repository pattern).
  - Unidirectional data flow diagram and explanation for viva presentation.
  - Step-by-step answers for examiner viva questions on BLoC, state transitions, debounce, and local storage.
  - Screenshots placeholder/section matching assignment submission guidelines.
- [x] Run `flutter analyze` and `flutter test` to ensure zero compilation or lint errors.
- [x] Verify complete user flow across all four tabs and all states (loading, loaded, empty, error, retry).
