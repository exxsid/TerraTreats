import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/review_card.dart';

class Reviews extends ConsumerStatefulWidget {
  const Reviews({super.key});

  @override
  ConsumerState<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends ConsumerState<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: Container(
        color: AppTheme.highlight,
        child: Column(
          children: [
            ReviewCard(content: "heheheheheh heheheh", reviewer: "Leo Anthony", rating: 5)
          ],
        ),
      ),
    );
  }
}
