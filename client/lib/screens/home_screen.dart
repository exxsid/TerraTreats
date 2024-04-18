import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/featured_notifier.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/featured_card.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    ref.read(featuredNotifierProvider.notifier).productName = "Ampalaya";
    ref.read(featuredNotifierProvider.notifier).productId = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FeaturedCard(),
          ],
        ),
      ),
    );
  }
}
