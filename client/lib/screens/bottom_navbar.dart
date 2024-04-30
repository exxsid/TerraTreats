import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:terratreats/screens/account_screen.dart";
import "package:terratreats/screens/home_screen.dart";
import "package:terratreats/screens/messages_screen.dart";
import "package:terratreats/screens/cart_screen.dart";
import "package:terratreats/screens/search_screen.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const Messages(),
    const Cart(),
    const Account(),
  ];

  void _botNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppTheme.highlight,
          title: const Text(
            "TerraTreats",
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          backgroundColor: AppTheme.highlight,
          actions: [
            searchButton(context),
          ],
        ),
        body: IndexedStack(
          index: ref.watch(navigationNotifierProvider).index,
          children: _screens,
        ),
        bottomNavigationBar: Consumer(
          builder: ((context, ref, child) {
            return BottomNavigationBar(
              onTap: (int index) {
                print("index: $index");
                ref
                    .read(navigationNotifierProvider.notifier)
                    .updateNavigationIndex(index);
                print("ref: ${ref.watch(navigationNotifierProvider).index}");
              },
              currentIndex: ref.watch(navigationNotifierProvider).index,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.home_outline),
                  activeIcon: Icon(Ionicons.home_sharp),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.chatbubble_ellipses_outline),
                  activeIcon: Icon(Ionicons.chatbubble_ellipses_sharp),
                  label: "Messages",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.cart_outline),
                  activeIcon: Icon(Ionicons.cart_sharp),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Ionicons.person_outline),
                  activeIcon: Icon(Ionicons.person_sharp),
                  label: "Account",
                ),
              ],
              backgroundColor: AppTheme.highlight,
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: const Color.fromARGB(255, 80, 82, 84),
              showUnselectedLabels: true,
            );
          }),
        ),
      ),
    );
  }

  IconButton searchButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Search();
          }),
        );
      },
      icon: Icon(Ionicons.search_outline),
      color: AppTheme.primary,
    );
  }
}
