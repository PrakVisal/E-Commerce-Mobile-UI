
class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String sizeOptions;
  final bool onPromotion;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sizeOptions,
    required this.onPromotion,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      sizeOptions: json['sizeOptions'] ?? '',
      onPromotion: json['onPromotion'] ?? false,
    );
  }
}
