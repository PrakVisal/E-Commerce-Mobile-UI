import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://spring.sikeat.me:8081',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/api/v1/products',
      options: Options(
          headers: {
          "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdHJpbmdAZ21haWwuY29tIiwiaWF0IjoxNzcyODI1OTg1LCJleHAiOjE3NzI4NDM5ODV9.iuEPiedVkUB4SIrkVhM-SltfI_ISvAyhCnAiDsP79lU7TpnbyaUk36WazNlrWl-m7SiT_gLGBOJ7M8cRv05OLA",
          }
      ),
      );

      // Handle both List and Map responses
      final List data;
      if (response.data is List) {
        data = response.data;
      } else if (response.data is Map<String, dynamic>) {
        // If the response is a Map, extract the products list
        data = response.data['payload'] ?? response.data['data'] ?? [];
      } else {
        data = [];
      }
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
