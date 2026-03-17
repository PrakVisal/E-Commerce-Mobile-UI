import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/services/wishlist_service.dart';
import 'package:flutter/material.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = WishlistService();

  var isLoading = false.obs;
  var wishlistItems = <Product>[].obs;

  // Keep track of liked IDs for O(1) lookups in UI
  var likedProductIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading(true);
      final products = await _wishlistService.getWishlist();
      wishlistItems.assignAll(products);

      // Update quick-lookup set
      likedProductIds.assignAll(products.map((p) => p.id!).toSet());
    } catch (e) {
      debugPrint('Error fetching wishlist: \$e');
    } finally {
      isLoading(false);
    }
  }

  bool isLiked(int? productId) {
    if (productId == null) return false;
    return likedProductIds.contains(productId);
  }

  Future<void> toggleWishlist(Product product) async {
    if (product.id == null) return;

    final productId = product.id!;
    final previouslyLiked = isLiked(productId);

    // Optimistically update UI
    if (previouslyLiked) {
      likedProductIds.remove(productId);
      wishlistItems.removeWhere((p) => p.id == productId);
    } else {
      likedProductIds.add(productId);
      wishlistItems.add(product);
    }

    try {
      final isNowInWaitlist = await _wishlistService.toggleWishlist(productId);

      // Reconcile optimistic update with actual server state just in case
      if (isNowInWaitlist != !previouslyLiked) {
        if (isNowInWaitlist) {
          likedProductIds.add(productId);
          if (!wishlistItems.any((p) => p.id == productId)) {
            wishlistItems.add(product);
          }
        } else {
          likedProductIds.remove(productId);
          wishlistItems.removeWhere((p) => p.id == productId);
        }
      }
    } catch (e) {
      // Revert optimistic update on failure
      Get.snackbar('Error', 'Failed to update wishlist',
          snackPosition: SnackPosition.BOTTOM);

      if (previouslyLiked) {
        likedProductIds.add(productId);
        if (!wishlistItems.any((p) => p.id == productId)) {
          wishlistItems.add(product);
        }
      } else {
        likedProductIds.remove(productId);
        wishlistItems.removeWhere((p) => p.id == productId);
      }
    }
  }
}
