import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/services/cart/cart_service.dart";
import "package:terratreats/widgets/cart_card.dart";
import "package:terratreats/utils/token_util.dart";

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int? userId = Token.getUserToken();

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.highlight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cart",
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                child: populateCartCard(),
                onRefresh: () async {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget populateCartCard() {
    print("CART: $userId");

    if (userId == null) {
      return const SingleChildScrollView(
        child: Center(
          child: Text("No product in the cart"),
        ),
      );
    }

    return FutureBuilder(
        future: getCarts(userId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final carts = snapshot.data!;
          return ListView.builder(
            itemCount: carts.length,
            itemBuilder: (context, index) {
              return CartCard(
                cartId: carts[index].cartId,
                productId: carts[index].productId,
                name: carts[index].name,
                imgUrl: carts[index].imgUrl,
                price: carts[index].price,
                unit: carts[index].unit,
                seller: carts[index].seller,
              );
            },
          );
        });
  }
}
