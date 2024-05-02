import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryCardItem {
  final int cardId;
  final String cardTitle;

  CategoryCardItem({
    required this.cardId,
    required this.cardTitle,
  });

  factory CategoryCardItem.fromJson(Map<String, dynamic> json) {
    return CategoryCardItem(
      cardId: json['category_id'] as int,
      cardTitle: json['category_name'] as String,
    );
  }
}

final categoryCardItemProvider =
    StateProvider<List<CategoryCardItem>>((ref) => []);

final categoryProductProvider = StateProvider<String>((ref) => "");