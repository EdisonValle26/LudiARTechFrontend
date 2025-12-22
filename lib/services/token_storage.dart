import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  /// Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Eliminar token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
