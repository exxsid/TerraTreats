import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SelectedProductNotifier extends ChangeNotifier {
  int id = 0;
}

final selectedProductNotifierProvider =
    ChangeNotifierProvider((ref) => SelectedProductNotifier());


class SelectedOrderSizeNotifier extends ChangeNotifier {
  int index = 0;

  void setSelectedOrderSize(int index) {
    this.index = index;
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
}

final orderQuantityNotifierProvider = ChangeNotifierProvider((ref) => OrderQuantityNotifier());