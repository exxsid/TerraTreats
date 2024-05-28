import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:terratreats/riverpod/selected_product_notifier.dart';
import 'package:terratreats/screens/selected_product_screen.dart';
import 'package:terratreats/services/seller_profile_util.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/loading_indacators.dart';
import 'package:terratreats/widgets/product_card.dart';

class SellerProfileScreen extends ConsumerStatefulWidget {
  final int sellerId;
  const SellerProfileScreen({super.key, required this.sellerId});

  @override
  ConsumerState<SellerProfileScreen> createState() =>
      _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    print("IIIIDDDD ${widget.sellerId}");
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileCard(),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Products",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              populateRecommendedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder profileCard() {
    return FutureBuilder(
      future: getSellerProfile(widget.sellerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator.circularLoader();
        }

        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text("Can't load seller profile"),
            ),
          );
        }

        final seller = snapshot.data!;

        return Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(
                      Ionicons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        seller.name,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        seller.address,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Description",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                seller.description,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  FutureBuilder populateRecommendedProducts() {
    return FutureBuilder(
      future: getSellerProducts(widget.sellerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final products = snapshot.data!;

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          children: List.generate(products.length, (index) {
            final prod = products[index];
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
      },
    );
  }
}
