import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthService {

  final Dio _dio = DioClient.dio;

  Future<String> login(String email, String password) async {

    final response = await _dio.post(
      "/api/v1/auths/login",
      data: {
        "email": email,
        "password": password
      },
    );

    final data = response.data;

    final token = data["payload"]?["token"];

    if (token == null) {
      throw Exception("Token not found in response");
    }

    return token;
  }
}