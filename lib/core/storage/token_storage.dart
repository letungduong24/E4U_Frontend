import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _key = "access_token";
  
  // Use secure storage for mobile platforms
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    if (kIsWeb) {
      // For web, use localStorage as fallback
      return;
    } else {
      await _secureStorage.write(key: _key, value: token);
    }
  }

  Future<String?> readToken() async {
    if (kIsWeb) {
      // For web, return null for now
      return null;
    } else {
      return await _secureStorage.read(key: _key);
    }
  }

  Future<void> deleteToken() async {
    if (kIsWeb) {
      // For web, do nothing for now
      return;
    } else {
      await _secureStorage.delete(key: _key);
    }
  }
}