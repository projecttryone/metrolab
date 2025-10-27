import 'package:shared_preferences/shared_preferences.dart';

class CacheStorage {
  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  // See everything stored in cache (all keys & values)
  static Future<Map<String, Object>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final map = <String, Object>{};
    for (var key in keys) {
      map[key] = prefs.get(key)!;
    }
    return map;
  }

  // Clear all data in cache
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
