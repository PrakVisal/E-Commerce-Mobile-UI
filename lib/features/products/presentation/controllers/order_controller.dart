import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();

  var isLoading = false.obs;
  var orders = <OrderModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _orderService.getOrders();
      orders.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
      debugPrint('Fetch orders error: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Places an order directly from a product (no CartItem needed).
  Future<OrderModel?> placeOrderDirect({
    required int productId,
    required int quantity,
    required double totalAmount,
    String productName = '',
    String productImageUrl = '',
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      final order = await _orderService.placeOrder(
        productId: productId,
        quantity: quantity,
        totalAmount: totalAmount,
      );
      // Enrich local model with known product info
      final enriched = OrderModel(
        id: order.id,
        productId: order.productId,
        productName: productName.isNotEmpty ? productName : order.productName,
        productImageUrl: productImageUrl.isNotEmpty
            ? productImageUrl
            : order.productImageUrl,
        quantity: order.quantity,
        totalAmount: order.totalAmount,
        status: order.status,
        createdAt: order.createdAt,
      );
      orders.insert(0, enriched);
      return enriched;
    } catch (e) {
      errorMessage(e.toString());
      debugPrint('Place order direct error: $e');
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      isLoading(true);
      errorMessage('');
      await _orderService.deleteOrder(orderId);
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: 'CANCELLED');
      }
      return true;
    } catch (e) {
      errorMessage(e.toString());
      debugPrint('Cancel order error: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
