import 'package:LudiArtech/models/certificate_response.dart';
import 'package:LudiArtech/models/lesson_status_model.dart';

import '../services/api_service.dart';
import '../utils/api_constants.dart';

class LessonService {
  final ApiService api;

  LessonService(this.api);

  Future<List<LessonStatusModel>> getLessonStatus({
    required String token,
  }) async {
    final response = await api.getAuth(
      ApiConstants.lessonStatus,
      token: token,
    );

    return (response as List)
        .map((e) => LessonStatusModel.fromJson(e))
        .toList();
  }

  Future<void> completeLesson({
    required String token,
    required int lessonId,
    required double score,
  }) async {
    await api.postAuth(
      ApiConstants.lessonComplete,
      token: token,
      body: {
        "lessonId": lessonId,
        "score": score,
      },
    );
  }

  Future<CertificateStatus> getCertificateStatus({
    required String token,
  }) async {
    final response = await api.getAuth(
      ApiConstants.certificateStatus,
      token: token,
    );

    if (response == null) {
      return CertificateStatus(
        canGet: false,
        fullname: "",
      );
    }

    return CertificateStatus.fromJson(response);
  }
}
