class MyOrdersModel {
  final int orderId;
  final String name;
  final String product;
  final String address;
  final String quantity;
  final double amount;
  final String status;

  MyOrdersModel({
    required this.orderId,
    required this.name,
    required this.product,
    required this.address,
    required this.quantity,
    required this.amount,
    required this.status,
  });

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) {
    return MyOrdersModel(
      orderId: json['order_id'],
      name: json['name'],
      product: json['product'],
      address: json['address'],
      quantity: json['quantity'],
      amount: json['amount'],
      status: json['status'],
    );
  }
}
