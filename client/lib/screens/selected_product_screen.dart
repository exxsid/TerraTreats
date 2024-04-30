import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:terratreats/models/product_model.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/services/selected_product_service.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/widgets/primary_button.dart";
import "package:terratreats/services/cart/cart_service.dart";
import "package:terratreats/utils/token_util.dart";
import "package:shared_preferences/shared_preferences.dart";

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
                          image: NetworkImage(data.imgUrl),
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
                            "0 sold",
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
                            ["7:00 am - 8:00 am", "11:00 am - 12:00 pm"],
                          ),
                          SizedBox(height: 16),
                          reviewBlock(),
                          SizedBox(height: 50),
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
                                print("selected $userId");
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
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return bottomViewSheet();
                              },
                            );
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

  Container deliveryScheduleBlock(List<String> sched) {
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              onPressed: () {},
            )
          ])
        ],
      ),
    );
  }

  Container bottomViewSheet() {
    List<ButtonSegment<String>> _segments = [
      _buttonSegment("1", "kilo"),
      _buttonSegment("3/4", "kilo"),
      _buttonSegment("1/2", "kilo"),
      _buttonSegment("1/4", "kilo"),
    ];

    String _selectedSegment = "3/4";

    int _orderQuantity = 1;

    TextEditingController _quantityController = TextEditingController(
        text: ref.watch(orderQuantityNotifierProvider).quantity.toString());

    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        color: AppTheme.highlight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // photo, product name, and price per unit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/placeholder.jpg'),
                            image: NetworkImage(
                                'https://res.cloudinary.com/db2ixxygt/image/upload/v1714314613/1/rod0e5uksdliodufyg1b.jpg'),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Name",
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "PHP 100.00 / Kilo",
                              style: TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // order option
                    SegmentedButton<String>(
                      segments: _segments,
                      selected: {_selectedSegment},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          print("TTAAANGGGIINNANAA ${newSelection.single}");
                          _selectedSegment = newSelection.single;
                        });
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // order quantity
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_orderQuantity == 1) return;
                              _orderQuantity--;
                              ref
                                  .read(orderQuantityNotifierProvider.notifier)
                                  .setOrderQuantity(_orderQuantity);
                              _quantityController.text =
                                  _orderQuantity.toString();
                            },
                            icon: Icon(Ionicons.remove_circle_outline),
                          ),
                          Container(
                            width: 20,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _quantityController,
                              onChanged: (value) {
                                ref
                                    .read(orderQuantityNotifierProvider.notifier)
                                    .setOrderQuantity(int.parse(value));
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _orderQuantity++;
                              _quantityController.text =
                                  _orderQuantity.toString();
                              ref
                                  .read(orderQuantityNotifierProvider.notifier)
                                  .setOrderQuantity(_orderQuantity);
                            },
                            icon: Icon(Ionicons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cash on delivery",
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Shipping Fee",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "PHP 10.00",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "PHP 60",
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              onPressed: () {},
              text: "Place Order",
            ),
          ],
        ),
      ),
    );
  }

  ButtonSegment<String> _buttonSegment(String size, String unit) {
    return ButtonSegment<String>(
      value: size,
      label: Text("$size / $unit"),
    );
  }
}
