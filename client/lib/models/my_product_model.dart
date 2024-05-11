class MyProductModel {
  final int productId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String unit;
  final String? image;
  final String category;
  final double shippingFee;

  MyProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.unit,
    required this.image,
    required this.category,
    required this.shippingFee,
  });

  factory MyProductModel.fromJson(Map<String, dynamic> json) {
    return MyProductModel(
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stokc'],
      unit: json['unit'],
      image: json['iamge'],
      category: json['category'],
      shippingFee: json['shipping_fee'],
    );
  }
}
