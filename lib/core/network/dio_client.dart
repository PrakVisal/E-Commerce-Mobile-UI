import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://spring.sikeat.me:8081",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {

        final token = await TokenStorage.getToken();

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },

      onError: (error, handler) async {

        if (error.response?.statusCode == 401) {
          await TokenStorage.clearToken();
        }

        return handler.next(error);
      },
    ),
  );
}