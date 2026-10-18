import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/watchlist_show.dart';

/// Persists the watchlist as a JSON array in SharedPreferences.
class WatchlistLocalDataSource {
  final SharedPreferences _prefs;

  WatchlistLocalDataSource(this._prefs);

  List<WatchlistShow> loadWatchlist() {
    try {
      final raw = _prefs.getString(kWatchlistKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => WatchlistShow.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data — return empty rather than crashing.
      return [];
    }
  }

  Future<void> saveWatchlist(List<WatchlistShow> shows) async {
    final encoded = jsonEncode(shows.map((s) => s.toJson()).toList());
    await _prefs.setString(kWatchlistKey, encoded);
  }
}
