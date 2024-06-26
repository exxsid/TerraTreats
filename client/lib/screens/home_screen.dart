import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/models/featured_product_model.dart';
import 'package:terratreats/riverpod/featured_notifier.dart';
import 'package:terratreats/riverpod/selected_product_notifier.dart';
import 'package:terratreats/screens/selected_product_screen.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/featured_card.dart';
import 'package:terratreats/widgets/category_card.dart';
import 'package:terratreats/widgets/product_card.dart';
import 'package:terratreats/riverpod/categorycard_notifier.dart';
import "package:terratreats/services/recommended_product_service.dart";
import "package:terratreats/services/featured_product_service.dart";

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              generateFeaturedProduct(),
              SizedBox(
                height: 24,
              ),
              Text(
                "Categories",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              CategoryCard(),
              SizedBox(
                height: 24,
              ),
              Text(
                "Recommended Products",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              populateRecommendedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder generateFeaturedProduct() {
    return FutureBuilder(
        future: getFeaturedProduct(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final featuredProduct = snapshot.data!;
          ref.read(featuredNotifierProvider.notifier).productName =
              featuredProduct.name;
          ref.read(featuredNotifierProvider.notifier).productId =
              featuredProduct.productId;
          ref.read(featuredNotifierProvider.notifier).imgUrl =
              featuredProduct.imgUrl;
          return FeaturedCard();
        });
  }

  FutureBuilder populateRecommendedProducts() {
    return FutureBuilder(
        future: getRecommendedProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final recommendedProducts = snapshot.data!;
          return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            children: List.generate(recommendedProducts.length, (index) {
              final prod = recommendedProducts[index];
              return IntrinsicHeight(
                child: ProductCard(
                  id: prod.productId,
                  name: prod.name,
                  price: prod.price,
                  unit: prod.unit,
                  rating: prod.rating,
                  seller: prod.seller,
                  imgUrl: prod.imgUrl,
                  sold: prod.sold,
                  onTap: () {
                    ref.read(selectedProductNotifierProvider.notifier).id =
                        prod.productId;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedProduct(),
                      ),
                    );
                  },
                ),
              );
            }),
          );
        });
  }
}
