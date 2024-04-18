import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/featured_notifier.dart';

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
                child: Image.network(
                  "https://res.cloudinary.com/db2ixxygt/image/upload/v1713418672/1/fwonrazdbprtuajcz4kk.jpg",
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
          print("Featured product tap");
        });
  }
}
