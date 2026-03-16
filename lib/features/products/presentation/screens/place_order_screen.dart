import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../../data/models/cart_item_model.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final CartController controller = Get.find<CartController>();
  final couponController = TextEditingController();

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text('Shopping Bag',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('Your cart is empty',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Cart Items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, idx) {
                  return _buildCartItem(controller.cartItems[idx]);
                },
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[200]),

              /// Apply Coupons Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    const Text('Apply Coupons',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // show coupon dialog
                      },
                      child: const Text('Select',
                          style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[200]),

              /// Order Payment Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Payment Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    _buildPaymentRow('Order Amounts',
                        '₹${controller.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Convenience',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {},
                              child: const Text('Know More',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFFFF6B6B))),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Apply Coupon',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFF6B6B),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentRow('Delivery Fee', 'Free'),
                  ],
                ),
              ),
              Divider(color: Colors.grey[200]),

              /// Order Summary
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  key: const ValueKey('order_summary_column'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Row(
                      key: const ValueKey('subtotal_row'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                        Obx(() => Text(
                            '₹${controller.subtotal.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      key: const ValueKey('delivery_fee_row'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                        Obx(() => Text(
                            '₹${controller.deliveryFee.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      key: const ValueKey('convenience_fee_row'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Convenience Fee',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                        Obx(() => Text(
                            '₹${controller.convenienceFee.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14))),
                      ],
                    ),
                    if (controller.appliedCouponDiscount.value > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Discount (${controller.appliedCouponCode.value})',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.green)),
                          Text(
                              '-₹${controller.appliedCouponDiscount.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.green)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('₹${controller.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('EMI Available',
                            style: TextStyle(fontSize: 14)),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Details',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFF6B6B),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Payment Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Amount',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('₹${controller.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {},
                              child: const Text('View Details',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFFFF6B6B))),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _proceedToPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B6B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Proceed to Payment',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        controller.removeFromCart(item);
                        Get.snackbar('Removed',
                            '${item.product.name} removed from cart');
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Size: ${item.selectedSize}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () {
                            if (item.quantity > 1) {
                              controller.updateQuantity(
                                  item, item.quantity - 1);
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            controller.updateQuantity(item, item.quantity + 1);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivery by ${DateTime.now().add(const Duration(days: 5)).toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Future<void> _proceedToPayment() async {
    if (controller.cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Create order data
    final orderData = {
      'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'items': controller.cartItems
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'price': item.product.price,
                'size': item.selectedSize,
                'subtotal': item.subtotal,
              })
          .toList(),
      'subtotal': controller.subtotal,
      'deliveryFee': controller.deliveryFee,
      'convenienceFee': controller.convenienceFee,
      'discount': controller.appliedCouponDiscount.value,
      'total': controller.total,
      'orderDate': DateTime.now().toIso8601String(),
      'status': 'confirmed',
    };

    print(
        '💳 Processing payment for order with ${controller.cartItems.length} items');
    print('💰 Payment total: ₹${controller.total.toStringAsFixed(2)}');

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 1));

    print('✅ Payment processed successfully');

    // Save order to local storage (simulate backend)
    _saveOrderToStorage(orderData);

    // Clear cart
    controller.clearCart();

    // Show success message
    Get.snackbar(
      'Payment Successful! 🎉',
      'Order ID: ${orderData['orderId']}\nTotal Paid: ₹${controller.total.toStringAsFixed(2)}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back to home
    Get.offAllNamed('/products');
  }

  Future<void> _saveOrderToStorage(Map<String, dynamic> orderData) async {
    try {
      // You could save to SharedPreferences or a local database
      // For now, just print the order (simulating backend save)
      print('📦 Order saved: ${orderData['orderId']}');
      print('💰 Total: ₹${orderData['total']}');
      print('📦 Items: ${orderData['items'].length}');

      // In a real app, you would send this to your backend API
      // await orderService.createOrder(orderData);
    } catch (e) {
      print('❌ Error saving order: $e');
    }
  }
}
