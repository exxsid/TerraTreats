import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/screens/place_order_screen.dart";
import "package:terratreats/screens/reviews_screen.dart";
import "package:terratreats/services/reviews_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/services/selected_product_service.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/widgets/loading_indacators.dart";
import "package:terratreats/widgets/primary_button.dart";
import "package:terratreats/services/cart/cart_service.dart";
import "package:terratreats/utils/preferences.dart";
import "package:terratreats/widgets/review_card.dart";

class SelectedProduct extends ConsumerStatefulWidget {
  const SelectedProduct({super.key});

  @override
  ConsumerState<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends ConsumerState<SelectedProduct> {
  List<String> _orderSizes = ["1", "3/4", "1/2", "1/4"];

  @override
  Widget build(BuildContext context) {
    final int id = ref.watch(selectedProductNotifierProvider).id;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getSelectedProduct(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 400,
                        child: FadeInImage(
                          image: AssetImage("assets/images/placeholder.jpg"),
                          placeholder:
                              AssetImage("assets/images/placeholder.jpg"),
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "PHP ${data.price} / ${data.unit}",
                                  style: TextStyle(
                                    color: AppTheme.secondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${data.rating} rating",
                                  style: TextStyle(
                                    color: AppTheme.secondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${data.seller}",
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${data.sold} sold",
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          descriptionBlock(data.description),
                          const SizedBox(height: 16),
                          deliveryScheduleBlock(
                            data.deliverySchedules ?? [],
                          ),
                          SizedBox(height: 16),
                          reviewBlock(),
                          SizedBox(height: 100),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // buy, add to cart and message
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.highlight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                          color: AppTheme.highlight,
                        ),
                        child: IconButton(
                            icon: Icon(Ionicons.chatbubble_outline),
                            onPressed: () {
                              print("cart pressed");
                            }),
                      ),
                      SizedBox(width: 8),
                      // add to cart button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                          color: AppTheme.secondary,
                        ),
                        child: IconButton(
                            icon: Icon(Ionicons.cart_outline),
                            onPressed: () async {
                              try {
                                final userId = Token.getUserToken();
                                final res = await addToCart(id, userId!);
                                if (!res) {
                                  return;
                                }

                                final snackBar = SnackBar(
                                  content: Text('Added to cart.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                ref
                                    .read(navigationNotifierProvider.notifier)
                                    .updateNavigationIndex(2);
                                Navigator.pop(context);
                              } on Exception catch (ex) {}
                            }),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: PrimaryButton(
                          text: "Buy",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return PlaceOrder(product: data);
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Container descriptionBlock(String desc) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              color: AppTheme.secondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Container deliveryScheduleBlock(List<dynamic> sched) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Schedule",
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16),
            child: Column(
              children: sched.map((time) {
                return Text(
                  time,
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container reviewBlock() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                child: Text("View all"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Reviews();
                  }));
                },
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 200,
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

                final reviews = snapshot.data!.take(3).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
        ],
      ),
    );
  }
}
