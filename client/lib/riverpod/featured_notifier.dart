import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeaturedNotifier extends ChangeNotifier {
  String productName = "";
  int productId = 0;
}

final featuredNotifierProvider =
    ChangeNotifierProvider((ref) => FeaturedNotifier());
