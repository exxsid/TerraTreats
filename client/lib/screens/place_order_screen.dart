import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/models/order_model.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";
import "package:terratreats/riverpod/selected_product_notifier.dart";
import "package:terratreats/services/order_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/utils/preferences.dart";
import "package:terratreats/widgets/primary_button.dart";

class PlaceOrder extends ConsumerStatefulWidget {
  const PlaceOrder({super.key});

  @override
  ConsumerState<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends ConsumerState<PlaceOrder> {
  ButtonSegment<String> _buttonSegment(String size, String unit) {
    return ButtonSegment<String>(
      value: size,
      label: Text("$size / $unit"),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonSegment<String>> _segments = [
      _buttonSegment("1", "kilo"),
      _buttonSegment("3/4", "kilo"),
      _buttonSegment("1/2", "kilo"),
      _buttonSegment("1/4", "kilo"),
    ];

    String _selectedSegment = ref.watch(selectedOrderSizeNotifierProvider).size;

    int _orderQuantity = ref.watch(orderQuantityNotifierProvider).quantity;

    TextEditingController _quantityController = TextEditingController(
        text: ref.watch(orderQuantityNotifierProvider).quantity.toString());

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        // height: 500,
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
                      productShortDetail(),
                      SizedBox(
                        height: 8,
                      ),
                      // order option
                      orderSizeOption(_segments, _selectedSegment),
                      SizedBox(
                        height: 8,
                      ),
                      // order quantity
                      orderQuantity(_orderQuantity, _quantityController),
                      SizedBox(
                        height: 8,
                      ),
                      shippingFeeDatail(),
                      totalAmountDetail(),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: () async {
                  try {
                    print("RRRUUUUGGGIIII");
                    await addToOrder(
                      Order(
                        userId: Token.getUserToken()!,
                        orderStatus: OrderStatus.pending,
                        shippingFee: 10,
                        productId: 11,
                        quantity:
                            ref.watch(orderQuantityNotifierProvider).quantity,
                        orderSize:
                            ref.watch(selectedOrderSizeNotifierProvider).size,
                      ),
                    );
                    final snackBar = SnackBar(
                      content: Text('Ordered Successfully.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } on Exception catch (e) {
                    print(e);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Place Order"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("Order failed"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Okay"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                text: "Place Order",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container totalAmountDetail() {
    return Container(
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
    );
  }

  Container shippingFeeDatail() {
    return Container(
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
    );
  }

  Container orderQuantity(
      int _orderQuantity, TextEditingController _quantityController) {
    return Container(
      child: Row(
        children: [
          IconButton(
            color: AppTheme.secondary,
            onPressed: () {
              if (_orderQuantity == 1) return;

              _quantityController.text =
                  ref.watch(orderQuantityNotifierProvider).quantity.toString();
              ref
                  .read(orderQuantityNotifierProvider.notifier)
                  .subtractQuantity();
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
            color: AppTheme.primary,
            onPressed: () {
              _quantityController.text = _orderQuantity.toString();

              ref.read(orderQuantityNotifierProvider.notifier).addQuantity();
            },
            icon: Icon(Ionicons.add_circle_sharp),
          ),
        ],
      ),
    );
  }

  SegmentedButton<String> orderSizeOption(
      List<ButtonSegment<String>> _segments, String _selectedSegment) {
    return SegmentedButton<String>(
      segments: _segments,
      selected: {_selectedSegment},
      onSelectionChanged: (Set<String> newSelection) {
        ref
            .read(selectedOrderSizeNotifierProvider.notifier)
            .setSelectedOrderSize(newSelection.first);
      },
    );
  }

  Row productShortDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/placeholder.jpg'),
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
    );
  }
}
