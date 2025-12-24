import 'package:LudiArtech/models/user_model.dart';

import '../services/api_service.dart';
import '../utils/api_constants.dart';

class UserService {
  final ApiService api;

  UserService(this.api);

  Future<void> createProfile({
    required String token,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required String course,
    required String phone,
    required String location,
  }) async {
    await api.postAuth(
      ApiConstants.userCreate,
      token: token,
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "gender": gender,
        "course": course,
        "phone": phone,
        "location": location,
      },
    );
  }

  Future<UserModel> getMe({
    required String token,
  }) async {
    final response = await api.getAuth(
      ApiConstants.userGet,
      token: token,
    );

    return UserModel.fromJson(response);
  }

  Future<void> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required String course,
    required String email,
    required String location,
  }) async {
    await api.putAuth(
      ApiConstants.userUpdate,
      token: token,
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "gender": gender,
        "course": course,
        "email": email,
        "location": location,
      },
    );
  }
}
