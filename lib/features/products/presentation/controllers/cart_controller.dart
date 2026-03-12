import 'package:get/get.dart';

import '../../data/models/cart_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var appliedCouponCode = Rxn<String>();
  var appliedCouponDiscount = 0.0.obs;

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
    } else {
      cartItems.add(item);
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
}
