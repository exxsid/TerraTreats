import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/widgets/add_review_card.dart';
import 'package:terratreats/widgets/appbar.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  final int orderID;
  final int productID;

  AddReviewScreen({
    super.key,
    required this.orderID,
    required this.productID,
  });

  @override
  ConsumerState<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends ConsumerState<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(title: "My Review"),
      body: Container(
        padding: EdgeInsets.all(8),
        child: AddReviewCard(
          orderID: widget.orderID,
          productID: widget.productID,
        ),
      ),
    );
  }
}
