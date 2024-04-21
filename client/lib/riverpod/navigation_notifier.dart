import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends ChangeNotifier {
  int index = 0;

  void updateNavigationIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}

final navigationNotifierProvider =
    ChangeNotifierProvider((ref) => NavigationNotifier());
