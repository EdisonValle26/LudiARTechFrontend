import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/api_exception.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  /// POST SIN TOKEN
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /// POST CON TOKEN
  Future<Map<String, dynamic>> postAuth(
    String endpoint, {
    required String token,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  ///MANEJO CENTRALIZADO DE RESPUESTAS
  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Error inesperado';

    if (decoded is Map<String, dynamic>) {
      final rawMessage = decoded['message'];

      if (rawMessage is String) {
        message = rawMessage;
      } else if (rawMessage is List) {
        message = rawMessage.join(', ');
      }
    }

    throw ApiException(message, response.statusCode);
  }
}
