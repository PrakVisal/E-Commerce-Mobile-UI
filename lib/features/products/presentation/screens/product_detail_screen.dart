import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/wishlist_controller.dart';
import 'order_confirmation_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImage = 0;
  int _quantity = 1;
  late final WishlistController _wishlistController;
  late final OrderController _orderController;

  @override
  void initState() {
    super.initState();
    _wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
    _orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = <String>[p.imageUrl];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final liked = _wishlistController.isLiked(p.id);
            return IconButton(
              icon: Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? const Color(0xFFFF6B6B) : Colors.black87,
              ),
              onPressed: () => _wishlistController.toggleWishlist(p),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Gallery ──────────────────────────────────────
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (idx) => setState(() => _currentImage = idx),
                    itemBuilder: (context, idx) => Image.network(
                      images[idx],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  // Page dots
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentImage == i
                                ? Colors.white
                                : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Name ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(p.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),

            // ── Category chip ──────────────────────────────────────
            if (p.category != null) _buildCategoryChip(p.category!),
            const SizedBox(height: 8),

            // ── Price ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B)),
                  ),
                  if (p.discount != null && p.discount! > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '\$${(p.price + p.discount!).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${((p.discount! / (p.price + p.discount!)) * 100).toStringAsFixed(0)}% Off',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Description ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text('Product Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(p.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ),
            const SizedBox(height: 24),

            // ── Quantity selector ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Quantity',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _qtyBtn(Icons.remove, () {
                          if (_quantity > 1) setState(() => _quantity--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_quantity',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        _qtyBtn(Icons.add, () => setState(() => _quantity++)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Total for this order ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                  Text(
                    '\$${(p.price * _quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Order Now button ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Wishlist button (outline)
                  Obx(() {
                    final liked = _wishlistController.isLiked(p.id);
                    return OutlinedButton(
                      onPressed: () => _wishlistController.toggleWishlist(p),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: liked
                                ? const Color(0xFFFF6B6B)
                                : Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color:
                            liked ? const Color(0xFFFF6B6B) : Colors.grey[600],
                      ),
                    );
                  }),
                  const SizedBox(width: 12),

                  // Order Now button (full width)
                  Expanded(
                    child: Obx(() {
                      final loading = _orderController.isLoading.value;
                      return ElevatedButton.icon(
                        onPressed: loading ? null : _placeOrder,
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.flash_on_rounded),
                        label: Text(loading ? 'Placing...' : 'Order Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Delivery banner ────────────────────────────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFFFCDD2),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Delivery in',
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('Within 1 Hour',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      );

  Widget _buildCategoryChip(String rawCategory) {
    ProductCategory? matched;
    try {
      matched = ProductCategory.values.firstWhere((e) => e.name == rawCategory);
    } catch (_) {
      matched = null;
    }
    final label = matched?.displayName ?? rawCategory;
    final icon = matched?.iconData ?? Icons.category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final p = widget.product;
    if (p.id == null) {
      Get.snackbar('Error', 'Invalid product',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final order = await _orderController.placeOrderDirect(
      productId: p.id!,
      quantity: _quantity,
      totalAmount: p.price * _quantity,
      productName: p.name,
      productImageUrl: p.imageUrl,
    );

    if (order != null) {
      Get.to(() => OrderConfirmationScreen(
            order: order,
            totalAmount: p.price * _quantity,
          ));
    } else {
      Get.snackbar(
        'Order Failed',
        _orderController.errorMessage.value.isNotEmpty
            ? _orderController.errorMessage.value
            : 'Something went wrong, please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }
}
