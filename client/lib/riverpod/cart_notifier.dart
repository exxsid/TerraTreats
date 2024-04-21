import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CartNotifier extends ChangeNotifier {
  late String id;
  late String name;
  late String imgUrl;
  late double price;
  late String unit;
  late String seller;
}

final cartNotifierProvider = ChangeNotifierProvider((ref) => CartNotifier());
