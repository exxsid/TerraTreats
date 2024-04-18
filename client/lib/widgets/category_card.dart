import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/riverpod/categorycard_notifier.dart';
import 'package:terratreats/services/category_service.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: FutureBuilder(
          future: getCategory(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Text("Can't load categories");
            }
            final categories = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.highlight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      "${categories[index].cardTitle}".toUpperCase(),
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
