import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/featured_notifier.dart';
import 'package:terratreats/riverpod/selected_product_notifier.dart';
import 'package:terratreats/screens/selected_product_screen.dart';

import 'package:terratreats/utils/app_theme.dart';

class FeaturedCard extends ConsumerWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 325,
                child: FadeInImage(
                  image:
                      NetworkImage(ref.watch(featuredNotifierProvider).imgUrl),
                  placeholder: AssetImage('assets/images/placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      ref.watch(featuredNotifierProvider).productName,
                      style: TextStyle(
                        color: AppTheme.highlight,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          ref.read(selectedProductNotifierProvider.notifier).id =
              ref.watch(featuredNotifierProvider).productId;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectedProduct()),
          );
        });
  }
}
