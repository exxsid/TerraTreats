import 'package:flutter/material.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:terratreats/services/seller/my_orders_service.dart';
import 'package:terratreats/widgets/appbar.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<String> _orderStatus = [
    'pending',
    'confirmed',
    'out for delivery',
    'delivered'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(title: "My Orders"),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: getMyOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final orders = snapshot.data!;
            return ScrollableTableView(
              headers: const [
                TableViewHeader(
                  label: "Name",
                  width: 150,
                ),
                TableViewHeader(
                  label: "Product",
                  width: 100,
                ),
                TableViewHeader(
                  label: "Address",
                  width: 100,
                ),
                TableViewHeader(
                  label: "Quantity",
                  width: 100,
                ),
                TableViewHeader(
                  label: "Amount",
                  width: 100,
                ),
                TableViewHeader(
                  label: "Status",
                  width: 200,
                ),
              ],
              rows: orders.map((order) {
                return TableViewRow(
                  height: 60,
                  cells: [
                    TableViewCell(
                      child: Text(order.name),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(8),
                    ),
                    TableViewCell(
                      child: Text(order.product),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(8),
                    ),
                    TableViewCell(
                      child: Text(order.address),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(8),
                    ),
                    TableViewCell(
                      child: Text(order.quantity),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(8),
                    ),
                    TableViewCell(
                      child: Text(order.amount.toString()),
                      padding: EdgeInsets.all(8),
                    ),
                    TableViewCell(
                      padding: EdgeInsets.all(8),
                      child: DropdownButton(
                        value: order.status,
                        items: _orderStatus
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (value) async {
                          try {
                            await updateMyOrderStatus(order.orderId, value!.replaceAll(RegExp(" "), "_"));
                            setState(() {
                              
                            });
                          } on Exception catch (e) {
                            final snackBar =
                                SnackBar(content: Text(e.toString()));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
