# 01: Core Infrastructure, Theme & Shell Foundation

**What to build:** Set up the core application foundation including third-party dependencies, custom dark theme with neon-violet accents, resilient HTTP network client with timeout and typed exceptions, reusable UI primitives (shimmer loaders, error retry views, rating badges), and the 4-tab bottom navigation shell (`IndexedStack`) preserving state across tabs.

**Blocked by:** None (can start immediately)

**Status:** closed

- [x] Add required dependencies to `pubspec.yaml` (`flutter_bloc`, `equatable`, `http`, `shared_preferences`, `cached_network_image`, `shimmer`, `google_fonts`, `rxdart`) and verify `flutter pub get`.
- [x] Create `AppTheme` in `lib/core/theme/` matching the dark palette (`#0F1016`, `#161822`, `#8B5CF6`, `#A855F7`) and modern typography.
- [x] Implement `ApiClient` in `lib/core/network/` wrapping `http` with a 15-second timeout and typed exceptions (`NetworkException`, `ServerException`, `NotFoundException`).
- [x] Implement reusable widgets (`ErrorView`, `ShimmerBox`, `RatingBadge`, `AppNetworkImage`, `InfoChip`) in `lib/core/widgets/`.
- [x] Implement `MainNavigationShell` in `lib/features/shell/` with persistent bottom navigation tabs (Home, Search, Watchlist, Profile) using `IndexedStack`.
