import 'user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;
  final bool firstLogin;

  AuthResponse({
    required this.token,
    required this.user,
    required this.firstLogin,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
      firstLogin: json['first_login']
    );
  }

  
}
