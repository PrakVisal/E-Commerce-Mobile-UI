import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../core/network/dio_client.dart';
import 'models/user_model.dart';

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
        throw Exception(
            "Login failed with status ${response.statusCode}: ${response.data}");
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

  /// Fetches the currently authenticated user's profile from the backend.
  ///
  /// The exact endpoint may need to be adjusted to match the server API
  /// (commonly `/api/v1/auths/me` or `/api/v1/users/profile`). The method
  /// handles both string and map payloads and attempts to locate the user
  /// object in several common places: `payload.user`, `data.user`, or the
  /// root of the response.
  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/api/v1/auths/profile');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }

      dynamic data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      // Handle various payload shapes from the backend
      Map<String, dynamic>? userJson;
      if (data is Map<String, dynamic>) {
        userJson = data['payload']?['user'] as Map<String, dynamic>? ??
            data['payload'] as Map<String, dynamic>? ??
            data['data']?['user'] as Map<String, dynamic>? ??
            data['data'] as Map<String, dynamic>? ??
            data['user'] as Map<String, dynamic>? ??
            data;
      }

      if (userJson == null) {
        throw Exception('No user data found in profile response: $data');
      }

      return User.fromJson(userJson);
    } catch (e) {
      print('Profile fetch error: $e');
      rethrow;
    }
  }

  /// Updates the user's profile with the provided [user] object.
  Future<void> updateProfile(User user) async {
    try {
      final response = await _dio.patch(
        '/api/v1/auths/profile',
        data: user.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Profile update error: $e');
      rethrow;
    }
  }

  Future<void> signup(String email, String password,
      {String? username, String? fullName}) async {
    try {
      print('Attempting signup for: $email');

      final response = await _dio.post(
        "/api/v1/auths/register",
        data: {
          "email": email,
          "password": password,
          "username": username ?? email.split('@')[0],
          "fullName": fullName ?? username ?? email.split('@')[0],
        },
      );

      print('Signup response status: ${response.statusCode}');
      print('Signup response data: ${response.data}');
      print('Signup response data type: ${response.data.runtimeType}');

      // Check if response is successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            "Signup failed with status ${response.statusCode}: ${response.data}");
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

      // Check for success
      if (data["success"] != true) {
        throw Exception("Signup failed: ${data["message"] ?? data}");
      }

      print('Signup successful for: $email');
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
