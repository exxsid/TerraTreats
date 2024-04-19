class FeaturedProduct {
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

  FeaturedProduct(
      {required this.productId,
      required this.name,
      required this.description,
      required this.price,
      required this.stock,
      required this.unit,
      required this.imgUrl,
      required this.rating,
      required this.category,
      required this.seller});

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "productId": int productId,
        "name": String name,
        "description": String description,
        "price": double price,
        "stock": int stock,
        "unit": String unit,
        "imgUrl": String imgUrl,
        "rating": double rating,
        "category": String category,
        "seller": String seller,
      } =>
        FeaturedProduct(
            productId: productId,
            name: name,
            description: description,
            price: price,
            stock: stock,
            unit: unit,
            imgUrl: imgUrl,
            rating: rating,
            category: category,
            seller: seller),
      _ => throw const FormatException('Failed to load Featured product.'),
    };
  }
}
