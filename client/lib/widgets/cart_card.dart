import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/screens/selected_product_screen.dart";
import "package:terratreats/utils/app_theme.dart";

class CartCard extends ConsumerWidget {
  final String cartId;
  final int productId;
  final String name;
  final String imgUrl;
  final double price;
  final String unit;
  final String seller;

  const CartCard({
    super.key,
    required this.cartId,
    required this.productId,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.unit,
    required this.seller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: Container(
        // cart card container
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppTheme.highlight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // card image container
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 150,
                  child: FadeInImage(
                    image: NetworkImage(this.imgUrl),
                    placeholder: AssetImage("assets/images/placeholder.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8),
                // the content of cart card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // title of card
                    Text(
                      this.name,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // price and unit
                    Text(
                      "PHP ${this.price} / ${this.unit}",
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // seller name
                    Text(
                      this.seller,
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            IconButton(
              color: Colors.red,
              icon: Icon(Ionicons.trash_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
      onTap: () {
        ref.read(selectedProductNotifierProvider.notifier).id = this.productId;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectedProduct()),
        );
      },
    );
  }
}
