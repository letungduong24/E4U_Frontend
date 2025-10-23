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
      final token = prefs.getString(_key);
      print('🌐 Web TokenStorage.readToken(): ${token != null ? "Found" : "Not found"}');
      if (token != null) {
        print('🌐 Token preview: ${token.substring(0, 20)}...');
      }
      return token;
    } else {
      final token = await _secureStorage.read(key: _key);
      print('📱 Mobile TokenStorage.readToken(): ${token != null ? "Found" : "Not found"}');
      return token;
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