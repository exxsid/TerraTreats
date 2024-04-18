import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SelectedProductNotifier extends ChangeNotifier {
  int id = 0;
}

final selectedProductNotifierProvider =
    ChangeNotifierProvider((ref) => SelectedProductNotifier());
