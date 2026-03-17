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
    return OrderModel(
      id: json['id'],
      productId: json['productId'] ?? json['product_id'] ?? 0,
      productName: json['productName'] ?? json['product_name'] ?? '',
      productImageUrl:
          json['productImageUrl'] ?? json['product_image_url'] ?? '',
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
}
