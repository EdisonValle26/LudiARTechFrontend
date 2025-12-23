import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
   static const _usernameKey = 'username';
  static const _fullnameKey = 'fullname';

  /// Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // USERNAME
  static Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  // FULLNAME
  static Future<void> saveFullname(String fullname) async {
    await _storage.write(key: _fullnameKey, value: fullname);
  }

  static Future<String?> getFullname() async {
    return await _storage.read(key: _fullnameKey);
  }

  /// Eliminar token (logout)
  static Future<void> deleteToken() async {
    await _storage.deleteAll();
  }
}
