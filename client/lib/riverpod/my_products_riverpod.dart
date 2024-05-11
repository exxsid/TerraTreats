import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProductNotifier extends ChangeNotifier {
  int productId = 0;
  String name = "";
  String description = "";
  double price = 0;
  int stock = 0;
  String unit = "";
  String? image;
  String category = "";
  double shippingFee = 0;

  void updateProductId(int id) {
    productId = id;
    notifyListeners();
  }

  void updateName(String name) {
    this.name = name;
    notifyListeners();
  }

  void updateDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  void updatePrice(double price) {
    this.price = price;
    notifyListeners();
  }

  void updateStock(int stock) {
    this.stock = stock;
    notifyListeners();
  }

  void updateUnit(String unit) {
    this.unit = unit;
    notifyListeners();
  }

  void updateImage(String image) {
    this.image = image;
    notifyListeners();
  }

  void updateCategory(String category) {
    this.category = category;
    notifyListeners();
  }

  void updateShippingFee(double shippingFee) {
    this.shippingFee = shippingFee;
    notifyListeners();
  }

  void reset() {
    productId = 0;
    name = "";
    description = "";
    price = 0;
    stock = 0;
    unit = "";
    image = null;
    category = "";
    shippingFee = 0;
    notifyListeners();
  }
}

final myProductNotifierProvider =
    ChangeNotifierProvider((ref) => MyProductNotifier());
