import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewRatingNotifier extends ChangeNotifier {
  double rating = 1;

  void updateRating(double rating) {
    this.rating = rating;
    notifyListeners();
  }
}

final reviewRatingNotifierProvider = ChangeNotifierProvider((ref) => ReviewRatingNotifier());

final reviewMessageProvider = StateProvider<String>((ref) => "");