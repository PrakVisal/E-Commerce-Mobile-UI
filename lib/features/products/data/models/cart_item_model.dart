import 'product_model.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;

  CartItem copyWith({
    Product? product,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }
}
