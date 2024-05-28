import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:terratreats/models/parcel_model.dart";
import "package:terratreats/screens/add_review_screen.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/widgets/add_review_card.dart";

class MyParcel extends StatefulWidget {
  final String title;
  final List<Parcel> parcels;

  const MyParcel({
    super.key,
    required this.title,
    required this.parcels,
  });

  @override
  State<MyParcel> createState() => _MyParcelState();
}

class _MyParcelState extends State<MyParcel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: AppTheme.highlight,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          color: AppTheme.highlight,
          child: (widget.parcels.length == 0
              ? Center(
                  child: Text('No Parcel Available'),
                )
              : ListView.builder(
                  itemCount: widget.parcels.length,
                  itemBuilder: (context, index) {
                    return parcelCard(
                      onTap: widget.title.contains("Review")
                          ? () {
                              print(widget.parcels[index].orderID);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddReviewScreen(
                                      orderID: widget.parcels[index].orderID,
                                      productID:
                                          widget.parcels[index].productId,
                                    );
                                  },
                                ),
                              );
                              setState(() {});
                            }
                          : () {},
                      productName: widget.parcels[index].productName,
                      imgUrl: widget.parcels[index].imgUrl,
                      price: widget.parcels[index].price,
                      unit: widget.parcels[index].unit,
                      rating: widget.parcels[index].rating,
                      seller: widget.parcels[index].seller,
                      orderSize: widget.parcels[index].orderSize,
                      totalPrice: widget.parcels[index].totalPrice,
                    );
                  },
                ))),
    );
  }

  InkWell parcelCard({
    required VoidCallback onTap,
    required String productName,
    required String imgUrl,
    required double price,
    required String unit,
    required double rating,
    required String seller,
    required String orderSize,
    required double totalPrice,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 100,
        width: double.infinity,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 165, 172, 175),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
          color: AppTheme.highlight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/placeholder.jpg'),
                image: NetworkImage(imgUrl),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    productName,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Php $price / $unit | ",
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "$rating rating",
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  seller,
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Php $totalPrice",
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "$orderSize $unit",
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
