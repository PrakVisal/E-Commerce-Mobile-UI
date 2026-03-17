import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl:
            "http://localhost:9090", // Using IP address instead of domain
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    )..interceptors.add(
        InterceptorsWrapper(
        onRequest: (options, handler) async {
            // Skip authorization for auth endpoints
            final isAuthEndpoint = options.path.contains('/auths/login') ||
                                   options.path.contains('/auths/register') ||
                                   options.path.contains('/auths/forgot-password');

            if (!isAuthEndpoint) {
              final token = await TokenStorage.getToken();
              if (token != null) {
                options.headers["Authorization"] = "Bearer $token";
              }
            }

            print('🌐 Request: ${options.method} ${options.uri}');
            print('📋 Headers: ${options.headers}');
            print('📦 Data: ${options.data}');

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('✅ Response: ${response.statusCode}');
            print('📄 Response data: ${response.data}');
            return handler.next(response);
          },
          onError: (error, handler) async {
            print('❌ Error: ${error.message}');
            print('🔍 Error type: ${error.type}');
            print('📄 Error response: ${error.response?.data}');

            if (error.response?.statusCode == 401) {
              await TokenStorage.clearToken();
            }

            return handler.next(error);
          },
        ),
      );

    return _dio!;
  }
}
