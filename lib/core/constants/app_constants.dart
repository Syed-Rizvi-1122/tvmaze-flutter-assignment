// API Endpoints
const String kBaseUrl = 'https://api.tvmaze.com';

// Endpoint builders
String showsEndpoint(int page) => '$kBaseUrl/shows?page=$page';
String searchShowsEndpoint(String query) =>
    '$kBaseUrl/search/shows?q=${Uri.encodeComponent(query)}';
String showDetailEndpoint(int id) => '$kBaseUrl/shows/$id';
String showCastEndpoint(int id) => '$kBaseUrl/shows/$id/cast';
String showEpisodesEndpoint(int id) => '$kBaseUrl/shows/$id/episodes';

// Pagination
const int kTrendingCount = 10;

// Storage keys
const String kWatchlistKey = 'watchlist_shows_v1';

// Debounce
const Duration kSearchDebounce = Duration(milliseconds: 500);

// Network timeouts
const Duration kApiTimeout = Duration(seconds: 15);
