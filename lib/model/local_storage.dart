import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  void saveSteamId(String? steamId) async {
    final prefs = await SharedPreferences.getInstance();

    if (steamId != null) {
      await prefs.setString('steamId', steamId);
    }
  }

  Future<String?> loadSteamId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('steamId');
  }

  void clearSteamId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}