import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SelectedProductNotifier extends ChangeNotifier {
  int id = 0;
}

final selectedProductNotifierProvider =
    ChangeNotifierProvider((ref) => SelectedProductNotifier());


class SelectedOrderSizeNotifier extends ChangeNotifier {
  String size = "1";

  void setSelectedOrderSize(String size) {
    this.size = size;
    notifyListeners();
  }
}

final selectedOrderSizeNotifierProvider = ChangeNotifierProvider((ref) => SelectedOrderSizeNotifier());

class OrderQuantityNotifier extends ChangeNotifier {
  int quantity = 1;

  void setOrderQuantity(int quantity) {
    this.quantity = quantity;
    notifyListeners();
  }

  void addQuantity() {
    ++quantity;
    notifyListeners();
  }

  void subtractQuantity() {
    --quantity;
    notifyListeners();
  }
}

final orderQuantityNotifierProvider = ChangeNotifierProvider((ref) => OrderQuantityNotifier());