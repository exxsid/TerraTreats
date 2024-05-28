class SellerProfileModel {
  final int sellerId;
  final String name;
  final String address;
  final String description;
  final bool isVerified;

  SellerProfileModel({
    required this.sellerId,
    required this.name,
    required this.address,
    required this.description,
    required this.isVerified,
  });

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "seller_id": int sellerId,
        "name": String name,
        "address": String address,
        "description": String description,
        "is_verified": bool isVerified,
      } =>
        SellerProfileModel(
          sellerId: sellerId,
          name: name,
          address: address,
          description: description,
          isVerified: isVerified,
        ),
      _ => throw const FormatException('Failed to load LoginService.'),
    };
  }
}
