enum OrderStatus {
  pending,
  confirmed,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final int userId;
  final OrderStatus orderStatus;
  final double shippingFee;
  final int productId;
  final int quantity;
  final String orderSize;

  Order({
    required this.userId,
    required this.orderStatus,
    required this.shippingFee,
    required this.productId,
    required this.quantity,
    required this.orderSize,
  });
}
