class Cart {
  final String cartId;
  final int productId;
  final String name;
  final String imgUrl;
  final double price;
  final String unit;
  final String seller;

  Cart({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.unit,
    required this.seller,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'] as String,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      price: json['price'] as double,
      unit: json['unit'] as String,
      seller: json['seller'] as String,
    );
  }
}
