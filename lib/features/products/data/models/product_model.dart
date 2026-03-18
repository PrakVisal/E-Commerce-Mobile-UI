import '../../../../core/network/file_service.dart';

class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool onPromotion;
  final String? category;
  final int? reviews;
  final double? discount;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onPromotion,
    this.category,
    this.reviews,
    this.discount,
  });

  double get discountedPrice {
    if (discount == null || discount == 0) return price;
    return price * (1 - (discount! / 100));
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl:
          FileService.getImageUrl(json['imageUrl'] ?? json['image_url'] ?? ''),
      onPromotion: json['onPromotion'] ?? json['on_promotion'] ?? false,
      category: json['category'],
      reviews: json['reviews'],
      discount:
          (json['discountPercentage'] ?? json['discount_percentage']) != null
              ? (json['discountPercentage'] ?? json['discount_percentage'] ?? 0)
                  .toDouble()
              : null,
    );
  }
}
