import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = DioClient.dio;

  Future<List<Product>> fetchProducts({
    String? category,
    bool? newArrivals,
    String? sortPrice,
    String? sortCreatedAt,
    bool? trending,
    String? name,
  }) async {
    try {
      final params = <String, dynamic>{
        if (category != null) 'category': category,
        if (newArrivals != null) 'newArrivals': newArrivals,
        if (sortPrice != null) 'sortPrice': sortPrice,
        if (sortCreatedAt != null) 'sortCreatedAt': sortCreatedAt,
        if (trending != null) 'trending': trending,
        if (name != null && name.isNotEmpty) 'name': name,
      };

      final response = await _dio.get(
        '/api/v1/products',
        queryParameters: params.isEmpty ? null : params,
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

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await _dio.get('/api/v1/products/$id');

      dynamic data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('payload')) {
        data = data['payload'];
      }

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid product data: $data');
      }

      return Product.fromJson(data);
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<bool> toggleWaitlist(int id) async {
    try {
      final response = await _dio.patch('/api/v1/products/$id/waitlist/toggle');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to toggle waitlist: ${response.statusCode}');
      }

      dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        data = data['payload'] ?? data;
        if (data is Map<String, dynamic>) {
          return data['inWaitlist'] == true;
        }
      }

      return true;
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<List<Product>> fetchWaitlist() async {
    try {
      final response = await _dio.get('/api/v1/products/waitlist');

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
