import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:terratreats/riverpod/selected_product_notifier.dart';
import 'package:terratreats/services/reviews_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/loading_indacators.dart';
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
        child: FutureBuilder(
          future: getReviews(ref.watch(selectedProductNotifierProvider).id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingIndicator.circularLoader();
            }

            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("There is an error getting the reviews"),
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return Container(
                child: Center(
                  child: Text("No Reviews"),
                ),
              );
            }

            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                    content: review.message,
                    reviewer: review.userName,
                    rating: review.rating.toDouble());
              },
            );
          },
        ),
      ),
    );
  }
}
