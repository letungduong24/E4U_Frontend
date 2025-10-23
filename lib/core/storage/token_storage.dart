import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = "access_token";
  
  // Use secure storage for mobile platforms
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    if (kIsWeb) {
      // For web, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, token);
    } else {
      await _secureStorage.write(key: _key, value: token);
    }
  }

  Future<String?> readToken() async {
    if (kIsWeb) {
      // For web, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_key);
    } else {
      return await _secureStorage.read(key: _key);
    }
  }

  Future<void> deleteToken() async {
    if (kIsWeb) {
      // For web, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } else {
      await _secureStorage.delete(key: _key);
    }
  }
}