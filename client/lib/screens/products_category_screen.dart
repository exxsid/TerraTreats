import "package:flutter/material.dart";
import "package:terratreats/riverpod/categorycard_notifier.dart";
import "package:terratreats/services/category_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/widgets/product_card.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ProductsCategory extends ConsumerStatefulWidget {
  const ProductsCategory({super.key});

  @override
  ConsumerState<ProductsCategory> createState() => _ProductsCategoryState();
}

class _ProductsCategoryState extends ConsumerState<ProductsCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.highlight,
        title: Text(ref.watch(categoryProductProvider.notifier).state, style: TextStyle(color: AppTheme.primary, fontSize: 20),),
      ),
      body: Container(
        color: AppTheme.highlight,
        child: FutureBuilder(
          future: getProductsByCategory(
              ref.watch(categoryProductProvider.notifier).state),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Center(
                child: Text("No Product Found"),
              );
            }

            final products = snapshot.data!;
            return GridView.count(
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
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
