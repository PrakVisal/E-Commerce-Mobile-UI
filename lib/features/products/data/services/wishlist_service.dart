import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';
import 'package:flutter/material.dart';

class WishlistService {
  final Dio _dio = DioClient.dio;

  Future<List<Product>> getWishlist() async {
    try {
      final response = await _dio.get('/api/v1/products/wishlist');

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['payload'] ?? response.data['data'] ?? [];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load wishlist");
      }
    } on DioException catch (e) {
      debugPrint('Wishlist fetch error: \$e');
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<bool> toggleWishlist(int productId) async {
    try {
      final response =
          await _dio.patch('/api/v1/products/$productId/wishlist/toggle');

      if (response.statusCode == 200) {
        final data = response.data['payload'] ?? response.data['data'];
        return data['inWishlist'] ?? false;
      }
      throw Exception("Failed to toggle wishlist");
    } on DioException catch (e) {
      debugPrint('Wishlist toggle error: \$e');
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
