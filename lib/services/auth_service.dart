import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class AuthService {
  final ApiService api;

  AuthService(this.api);

  // LOGIN
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await api.post(
      ApiConstants.login,
      body: {
        "username": username,
        "password": password,
      },
    );

    return AuthResponse.fromJson(response);
  }

  // REGISTER
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await api.post(
      ApiConstants.register,
      body: {
        "username": username,
        "email": email,
        "password": password,
      },
    );
  }

  // CHANGE PASSWORD
  Future<void> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    await api.postAuth(
      ApiConstants.changePassword,
      token: token,
      body: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
    );
  }
}
