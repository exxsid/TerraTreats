import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/screens/selected_product_screen.dart";
import "package:terratreats/utils/app_theme.dart";

class ProductCard extends ConsumerWidget {
  final int id;
  final String name;
  final double price;
  final String unit;
  final double rating;
  final String seller;
  final String imgUrl;
  final int sold;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.rating,
    required this.seller,
    required this.imgUrl,
    required this.sold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.highlight,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 150,
                child: FadeInImage(
                  image: NetworkImage(this.imgUrl),
                  placeholder: AssetImage("assets/images/placeholder.jpg"),
                  fit: BoxFit.cover,
                )),
            Text(
              this.name.toUpperCase(),
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(children: [
              Expanded(
                child: Text(
                  "PHP ${this.price} / ${this.unit}",
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "${this.rating} rating",
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ]),
            Text(
              this.seller,
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: 12,
              ),
            ),
            Text(
              "${this.sold} sold",
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print("product tapped ${this.id}");
        ref.read(selectedProductNotifierProvider.notifier).id = this.id;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectedProduct()),
        );
      },
    );
  }
}
