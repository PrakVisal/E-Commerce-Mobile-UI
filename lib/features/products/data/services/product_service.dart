import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductService {

  final Dio _dio = DioClient.dio;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/api/v1/products');

      final List data;

      if (response.data is List) {
        data = response.data;
      } else if (response.data is Map<String, dynamic>) {
        data = response.data['payload'] ?? response.data['data'] ?? [];
      } else {
        data = [];
      }

      return data.map((json) => Product.fromJson(json)).toList();

    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }
}