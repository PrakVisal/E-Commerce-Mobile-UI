import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = DioClient.dio;

  Future<Product> updateDiscount(int id, double percentage) async {
    try {
      final response = await _dio.patch('/products/$id/discount', data: {
        'discountPercentage': percentage,
      });
      return Product.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update discount: $e');
    }
  }

  Future<List<Product>> fetchProducts({
    String? category,
    bool? newArrivals,
    bool? trending,
    String? name,
    String? sortPrice,
    String? sortCreatedAt,
    bool? onPromotion,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (category != null && category != "All") {
        queryParameters['category'] = category;
      }
      if (newArrivals != null) queryParameters['newArrivals'] = newArrivals;
      if (trending != null) queryParameters['trending'] = trending;
      if (name != null && name.isNotEmpty) queryParameters['name'] = name;
      if (sortPrice != null) queryParameters['sortPrice'] = sortPrice;
      if (sortCreatedAt != null) {
        queryParameters['sortCreatedAt'] = sortCreatedAt;
      }
      if (onPromotion != null) queryParameters['onPromotion'] = onPromotion;

      final response = await _dio.get(
        '/api/v1/products',
        queryParameters: queryParameters,
      );

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
