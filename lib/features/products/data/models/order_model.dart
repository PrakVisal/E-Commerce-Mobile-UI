class OrderModel {
  final int? id;
  final int productId;
  final String productName;
  final String productImageUrl;
  final int quantity;
  final double totalAmount;
  final String status;
  final String? createdAt;

  /// The KHQR payment string returned by the backend — used to call /qr-image
  final String? qr;

  OrderModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.totalAmount,
    this.status = 'PENDING',
    this.createdAt,
    this.qr,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>?;

    return OrderModel(
      id: json['id'],
      productId:
          json['productId'] ?? json['product_id'] ?? productJson?['id'] ?? 0,
      productName: json['productName'] ??
          json['product_name'] ??
          productJson?['name'] ??
          '',
      productImageUrl: json['productImageUrl'] ??
          json['product_image_url'] ??
          productJson?['imageUrl'] ??
          '',
      quantity: json['quantity'] ?? 1,
      totalAmount:
          (json['totalAmount'] ?? json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] ?? json['created_at'],
      qr: json['qr']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'totalAmount': totalAmount,
      };

  OrderModel copyWith({
    int? id,
    int? productId,
    String? productName,
    String? productImageUrl,
    int? quantity,
    double? totalAmount,
    String? status,
    String? createdAt,
    String? qr,
  }) {
    return OrderModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      qr: qr ?? this.qr,
    );
  }
}
