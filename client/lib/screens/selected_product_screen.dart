import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:terratreats/models/product_model.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/services/selected_product_service.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/widgets/primary_button.dart";

class SelectedProduct extends ConsumerStatefulWidget {
  const SelectedProduct({super.key});

  @override
  ConsumerState<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends ConsumerState<SelectedProduct> {
  @override
  Widget build(BuildContext context) {
    final int id = ref.watch(selectedProductNotifierProvider).id;
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: getSelectedProduct(id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return Text("Can't load product");
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
                          child: Image.network(
                            data.imgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                              SizedBox(
                                height: 8,
                              ),
                              Row(children: [
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
                              ]),
                              Text(
                                "${data.seller}",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                " 0 sold",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Description",
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${data.description}",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 16),
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
                                child: Column(children: [
                                  Text(
                                    "7:00 am - 8:00 am",
                                    style: TextStyle(
                                      color: AppTheme.secondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Reviews",
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.highlight,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Ionicons.cart_outline),
                              onPressed: () {
                                print("cart pressed");
                              }),
                          Flexible(
                            child: PrimaryButton(
                              text: "Buy",
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
