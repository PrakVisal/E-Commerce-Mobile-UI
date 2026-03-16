import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../data/models/cart_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var appliedCouponCode = Rxn<String>();
  var appliedCouponDiscount = 0.0.obs;

  static const String _cartItemsKey = 'cart_items';
  static const String _couponCodeKey = 'coupon_code';
  static const String _couponDiscountKey = 'coupon_discount';

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();

    // Save cart whenever it changes
    ever(cartItems, (_) => _saveCartToStorage());
    ever(appliedCouponCode, (_) => _saveCouponToStorage());
    ever(appliedCouponDiscount, (_) => _saveCouponToStorage());
  }

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get deliveryFee {
    return subtotal > 0 ? 0.0 : 0.0; // free always for now
  }

  double get convenienceFee {
    return subtotal * 0.02; // 2% convenience fee
  }

  double get total {
    return subtotal +
        deliveryFee +
        convenienceFee -
        appliedCouponDiscount.value;
  }

  void addToCart(CartItem item) {
    // check if product already exists
    final existingIndex = cartItems.indexWhere(
      (ci) =>
          ci.product.id == item.product.id &&
          ci.selectedSize == item.selectedSize,
    );

    if (existingIndex >= 0) {
      // update quantity
      final updated = cartItems[existingIndex].copyWith(
          quantity: cartItems[existingIndex].quantity + item.quantity);
      cartItems[existingIndex] = updated;
      print(
          '🔄 Updated quantity for ${item.product.name} (Size: ${item.selectedSize}) to ${updated.quantity}');
    } else {
      cartItems.add(item);
      print(
          '➕ Added ${item.product.name} (Size: ${item.selectedSize}) to cart. Total items: ${cartItems.length}');
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.removeWhere(
      (ci) =>
          ci.product.id == item.product.id &&
          ci.selectedSize == item.selectedSize,
    );
  }

  void updateQuantity(CartItem item, int newQuantity) {
    final index = cartItems.indexWhere(
      (ci) =>
          ci.product.id == item.product.id &&
          ci.selectedSize == item.selectedSize,
    );

    if (index >= 0) {
      if (newQuantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index] = item.copyWith(quantity: newQuantity);
      }
    }
  }

  void applyCoupon(String code, double discount) {
    appliedCouponCode.value = code;
    appliedCouponDiscount.value = discount;
  }

  void removeCoupon() {
    appliedCouponCode.value = null;
    appliedCouponDiscount.value = 0.0;
  }

  void clearCart() {
    cartItems.clear();
    appliedCouponCode.value = null;
    appliedCouponDiscount.value = 0.0;
  }

  // Clear local storage (for testing/debugging)
  Future<void> clearLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartItemsKey);
      await prefs.remove(_couponCodeKey);
      await prefs.remove(_couponDiscountKey);
      print('🗑️ Cleared all cart data from local storage');
    } catch (e) {
      print('❌ Error clearing local storage: $e');
    }
  }

  // Local Storage Methods
  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load cart items
      final cartItemsJson = prefs.getString(_cartItemsKey);
      if (cartItemsJson != null) {
        final List<dynamic> decoded = json.decode(cartItemsJson);
        cartItems.value =
            decoded.map((item) => CartItem.fromJson(item)).toList();
        print('✅ Loaded ${cartItems.length} items from local storage');
      }

      // Load coupon data
      final couponCode = prefs.getString(_couponCodeKey);
      final couponDiscount = prefs.getDouble(_couponDiscountKey) ?? 0.0;

      if (couponCode != null) {
        appliedCouponCode.value = couponCode;
        appliedCouponDiscount.value = couponDiscount;
        print('✅ Loaded coupon: $couponCode with discount: $couponDiscount');
      }
    } catch (e) {
      print('❌ Error loading cart from storage: $e');
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartItemsJson =
          json.encode(cartItems.map((item) => item.toJson()).toList());
      await prefs.setString(_cartItemsKey, cartItemsJson);
      print('💾 Saved ${cartItems.length} items to local storage');
    } catch (e) {
      print('❌ Error saving cart to storage: $e');
    }
  }

  Future<void> _saveCouponToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (appliedCouponCode.value != null) {
        await prefs.setString(_couponCodeKey, appliedCouponCode.value!);
        await prefs.setDouble(_couponDiscountKey, appliedCouponDiscount.value);
      } else {
        await prefs.remove(_couponCodeKey);
        await prefs.remove(_couponDiscountKey);
      }
    } catch (e) {
      print('Error saving coupon to storage: $e');
    }
  }
}
