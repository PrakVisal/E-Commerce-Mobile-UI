import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class NewArrivalsProductsScreen extends StatelessWidget {
  const NewArrivalsProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Arrivals'),
      ),
      body: Obx(() {
        final newArrivals = controller.getNewArrivals();

        if (controller.isTrendingLoading.value && newArrivals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (newArrivals.isEmpty) {
          return const Center(child: Text('No new arrivals found'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: GridView.builder(
            itemCount: newArrivals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(
                    () => ProductDetailScreen(product: newArrivals[index])),
                child: _buildProductGridCard(newArrivals[index]),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildProductGridCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  width: double.infinity,
                  height: 140,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              if (product.onPromotion)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Sale",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              // Heart / wishlist toggle
              Positioned(
                top: 8,
                left: 8,
                child: Obx(() {
                  final wc = Get.isRegistered<WishlistController>()
                      ? Get.find<WishlistController>()
                      : Get.put(WishlistController());
                  final liked = wc.isLiked(product.id);
                  return GestureDetector(
                    onTap: () => wc.toggleWishlist(product),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color:
                            liked ? const Color(0xFFFF6B6B) : Colors.grey[600],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                if (product.discount != null && product.discount! > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(1)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        "\$${product.discountedPrice.toStringAsFixed(1)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    "\$${product.price.toStringAsFixed(1)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
