import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/api_exception.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  //POST SIN TOKEN
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  //POST CON TOKEN
  Future<dynamic> postAuth(
    String endpoint, {
    required String token,
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  //GET CON TOKEN
  Future<dynamic> getAuth(
    String endpoint, {
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
    );

    return _handleResponse(response);
  }

  //PUT CON TOKEN
  Future<dynamic> putAuth(
    String endpoint, {
    required String token,
    Map<String, dynamic>? body,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
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
