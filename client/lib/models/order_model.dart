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

  Order({
    required this.userId,
    required this.orderStatus,
    required this.shippingFee,
  });
}
