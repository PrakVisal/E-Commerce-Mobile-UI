import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';
import '../models/order_model.dart';

class OrderService {
  final Dio _dio = DioClient.dio;

  Future<OrderModel> placeOrder({
    required int productId,
    required int quantity,
    required double totalAmount,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/orders',
        data: {
          'productId': productId,
          'quantity': quantity,
          'totalAmount': totalAmount,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            response.data['payload'] ?? response.data['data'] ?? response.data;
        return OrderModel.fromJson(data);
      }
      throw Exception('Failed to place order');
    } on DioException catch (e) {
      debugPrint('Place order error: $e');
      throw Exception(
          e.response?.data?['message'] ?? e.message ?? 'Order failed');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.get('/api/v1/orders/me');

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['payload'] ?? response.data['data'] ?? [];
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch orders');
    } on DioException catch (e) {
      debugPrint('Get orders error: $e');
      throw Exception(
          e.response?.data?['message'] ?? e.message ?? 'Fetch failed');
    }
  }

  Future<OrderModel> refreshPaymentStatus(int orderId) async {
    try {
      final response =
          await _dio.patch('/api/v1/orders/$orderId/payment/refresh');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            response.data['payload'] ?? response.data['data'] ?? response.data;
        return OrderModel.fromJson(data);
      }
      throw Exception('Failed to refresh payment status');
    } on DioException catch (e) {
      debugPrint('Refresh payment error: $e');
      throw Exception(
          e.response?.data?['message'] ?? e.message ?? 'Refresh failed');
    }
  }
}
