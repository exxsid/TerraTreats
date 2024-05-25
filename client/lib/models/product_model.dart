class Product {
  final int productId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String unit;
  final String imgUrl;
  final double rating;
  final String category;
  final String seller;
  int? sellerId;
  final int sold;
  final double shippingFee;
  List<dynamic>? deliverySchedules;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.unit,
    required this.imgUrl,
    required this.rating,
    required this.category,
    required this.seller,
    this.sellerId,
    required this.sold,
    required this.shippingFee,
    this.deliverySchedules,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      stock: json['stock'] as int,
      unit: json['unit'] as String,
      imgUrl: json['imgUrl'] as String,
      rating: json['rating'] as double,
      category: json['category'] as String,
      seller: json['seller'] as String,
      sold: json['sold'] as int,
      shippingFee: json['shipping_fee'] as double,
      deliverySchedules: json['schedule'] as List<dynamic>,
    );
  }

  factory Product.selectedProduct(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      stock: json['stock'] as int,
      unit: json['unit'] as String,
      imgUrl: json['imgUrl'] as String,
      rating: json['rating'] as double,
      category: json['category'] as String,
      seller: json['seller'] as String,
      sellerId: json['seller_id'] as int,
      sold: json['sold'] as int,
      shippingFee: json['shipping_fee'] as double,
      deliverySchedules: json['schedule'] as List<dynamic>,
    );
  }
}
