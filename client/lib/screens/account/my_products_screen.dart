import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:terratreats/models/product_model.dart';
import 'package:terratreats/screens/account/add_product_screen.dart';
import 'package:terratreats/screens/account/edit_my_products_screen.dart';
import 'package:terratreats/services/seller/my_products_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/appbar.dart';
import 'package:terratreats/widgets/product_card.dart';

class MyProducstScreen extends ConsumerStatefulWidget {
  const MyProducstScreen({super.key});

  @override
  ConsumerState<MyProducstScreen> createState() => _MyProducstScreenState();
}

class _MyProducstScreenState extends ConsumerState<MyProducstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(title: "My Products"),
      body: Stack(
        children: [
          RefreshIndicator(
            child: myProducts(),
            onRefresh: () async {
              setState(() {});
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: AppTheme.primary,
              child: Icon(
                Ionicons.add_outline,
                color: Colors.white70,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddProductScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget myProducts() {
    return FutureBuilder(
      future: getMyProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text("Can't get your products"),
            ),
          );
        }

        final myProducts = snapshot.data!;
        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          children: List.generate(myProducts.length, (index) {
            final prod = myProducts[index];
            return ProductCard(
              id: prod.productId,
              name: prod.name,
              price: prod.price,
              unit: prod.unit,
              rating: prod.rating,
              seller: prod.seller,
              imgUrl: prod.imgUrl,
              sold: prod.sold,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return EditMyProducts(productId: prod.productId);
                  },
                ));
              },
            );
          }),
        );
      },
    );
  }
}
