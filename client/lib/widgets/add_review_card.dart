import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/review_notifier.dart';
import 'package:terratreats/services/order_service.dart';
import 'package:terratreats/utils/app_theme.dart';

class AddReviewCard extends ConsumerWidget {
  final int orderID;
  final int productID;

  AddReviewCard({
    super.key,
    required this.orderID,
    required this.productID,
  });

  final _formKey = GlobalKey<FormState>();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: ref
                          .watch(reviewRatingNotifierProvider.notifier)
                          .rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        ref
                            .read(reviewRatingNotifierProvider.notifier)
                            .updateRating(rating);
                      },
                    ),
                    Text(ref
                        .watch(reviewRatingNotifierProvider)
                        .rating
                        .toString()),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Add a review here...',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                  ),
                  onChanged: (value) {
                    ref.read(reviewMessageProvider.notifier).state = value;
                  },
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    // await addReview(
                    //     ref.watch(reviewRatingNotifierProvider).rating,
                    //     ref.watch(reviewMessageProvider.notifier).state,
                    //     orderID,
                    //     productID);

                    final snackBar = SnackBar(
                      content: Text('Thank you for your review.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Submit review",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
