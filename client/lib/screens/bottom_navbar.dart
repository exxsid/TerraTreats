import "package:flutter/material.dart";

import "package:terratreats/utils/app_theme.dart";

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TerraTreats"),
          backgroundColor: AppTheme.highlight,
        ),
      ),
    );
  }
}
