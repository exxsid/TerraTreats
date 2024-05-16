class Parcel {
  final int productId;
  final String productName;
  final String imgUrl;
  final double price;
  final String unit;
  final double rating;
  final String seller;
  final String orderSize;
  final double totalPrice;
  final int orderID;

  Parcel({
    required this.productId,
    required this.productName,
    required this.imgUrl,
    required this.price,
    required this.unit,
    required this.rating,
    required this.seller,
    required this.orderSize,
    required this.totalPrice,
    required this.orderID,
  });

  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      imgUrl: json['img_url'] as String,
      price: json['price'] as double,
      unit: json['unit'] as String,
      rating: json['rating'] as double,
      seller: json['seller'] as String,
      orderSize: json['order_size'] as String,
      totalPrice: json['total_price'] as double,
      orderID: json['order_id'] as int,
    );
  }
}
