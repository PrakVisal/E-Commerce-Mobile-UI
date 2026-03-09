import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../core/network/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  Future<String> login(String email, String password) async {
    try {
      print('Attempting login for: $email');

      final response = await _dio.post(
        "/api/v1/auths/login",
        data: {"email": email, "password": password},
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');
      // Check if response is successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Login failed with status ${response.statusCode}: ${response.data}");
      }
      dynamic data = response.data;
      if (data is String) {
        // If response is a string, try to parse it as JSON
        try {
          data = jsonDecode(data);
        } catch (e) {
          throw Exception("Invalid response format: $data");
        }
      }

      // Ensure data is a Map
      if (data is! Map<String, dynamic>) {
        throw Exception("Response is not a valid JSON object: $data");
      }

      final token = data["payload"]?["token"] ?? data["token"];

      if (token == null) {
        throw Exception("Token not found in response: $data");
      }

      // Ensure token is a string
      if (token is! String) {
        throw Exception("Token is not a string: $token");
      }

      return token;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<String> signup(String email, String password) async {
    try {
      print('Attempting signup for: $email');

      final response = await _dio.post(
        "/api/v1/auths/register",
        data: {"email": email, "password": password},
      );

      print('Signup response status: ${response.statusCode}');
      print('Signup response data: ${response.data}');
      print('Signup response data type: ${response.data.runtimeType}');

      // Check if response is successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Signup failed with status ${response.statusCode}: ${response.data}");
      }

      // Handle different response formats
      dynamic data = response.data;
      if (data is String) {
        // If response is a string, try to parse it as JSON
        try {
          data = jsonDecode(data);
        } catch (e) {
          throw Exception("Invalid response format: $data");
        }
      }

      // Ensure data is a Map
      if (data is! Map<String, dynamic>) {
        throw Exception("Response is not a valid JSON object: $data");
      }

      final token = data["payload"]?["token"] ?? data["token"];

      if (token == null) {
        throw Exception("Token not found in response: $data");
      }

      // Ensure token is a string
      if (token is! String) {
        throw Exception("Token is not a string: $token");
      }

      return token;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      print('Attempting forgot password for: $email');

      final response = await _dio.post(
        "/api/v1/auths/forgot-password",
        data: {"email": email},
      );

      print('Forgot password response status: ${response.statusCode}');
      print('Forgot password response data: ${response.data}');
      print('Forgot password response data type: ${response.data.runtimeType}');

      // Handle different response formats
      dynamic data = response.data;
      if (data is String) {
        // If response is a string, try to parse it as JSON
        try {
          data = jsonDecode(data);
        } catch (e) {
          throw Exception("Invalid response format: $data");
        }
      }

      // Ensure data is a Map
      if (data is! Map<String, dynamic>) {
        throw Exception("Response is not a valid JSON object: $data");
      }

      if (data["success"] != true) {
        throw Exception("Failed to send password reset email: $data");
      }
    } catch (e) {
      print('Forgot password error: $e');
      rethrow;
    }
  }
}
