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
}
