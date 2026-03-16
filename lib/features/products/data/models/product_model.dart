class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String sizeOptions;
  final bool onPromotion;
  final String? category;
  final double? rating;
  final int? reviews;
  final double? discount;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sizeOptions,
    required this.onPromotion,
    this.category,
    this.rating,
    this.reviews,
    this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      sizeOptions: json['sizeOptions'] ?? json['size_options'] ?? '',
      onPromotion: json['onPromotion'] ?? json['on_promotion'] ?? false,
      category: json['category'],
      rating: json['rating'] != null ? (json['rating']).toDouble() : null,
      reviews: json['reviews'],
      discount: json['discount'] != null ? (json['discount']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sizeOptions': sizeOptions,
      'onPromotion': onPromotion,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'discount': discount,
    };
  }
}
