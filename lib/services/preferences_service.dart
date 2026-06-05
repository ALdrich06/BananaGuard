import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService instance = PreferencesService._init();
  SharedPreferences? _prefs;

  PreferencesService._init();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveUser({
    required String name,
    required String email,
    String? password,
  }) async {
    final p = await prefs;
    await p.setString('user_name', name);
    await p.setString('user_email', email);
    if (password != null) {
      await p.setString('user_password', password);
    }
    await p.setBool('is_logged_in', true);
  }

  Future<Map<String, String?>> getUser() async {
    final p = await prefs;
    return {
      'name': p.getString('user_name'),
      'email': p.getString('user_email'),
      'password': p.getString('user_password'),
    };
  }

  Future<bool> isLoggedIn() async {
    final p = await prefs;
    return p.getBool('is_logged_in') ?? false;
  }

  Future<void> logout() async {
    final p = await prefs;
    await p.setBool('is_logged_in', false);
  }

  Future<void> setLanguage(String language) async {
    final p = await prefs;
    await p.setString('language', language);
  }

  Future<String> getLanguage() async {
    final p = await prefs;
    return p.getString('language') ?? 'English';
  }

  Future<void> setDarkMode(bool enabled) async {
    final p = await prefs;
    await p.setBool('dark_mode', enabled);
  }

  Future<bool> getDarkMode() async {
    final p = await prefs;
    return p.getBool('dark_mode') ?? false;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final p = await prefs;
    await p.setBool('notifications_enabled', enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final p = await prefs;
    return p.getBool('notifications_enabled') ?? true;
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    final p = await prefs;
    await p.setBool('first_launch', isFirst);
  }

  Future<bool> isFirstLaunch() async {
    final p = await prefs;
    return p.getBool('first_launch') ?? true;
  }

  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }
}
