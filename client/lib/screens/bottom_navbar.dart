import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";

import "package:terratreats/screens/account_screen.dart";
import "package:terratreats/screens/home_screen.dart";
import "package:terratreats/screens/messages_screen.dart";
import "package:terratreats/screens/cart_screen.dart";
import "package:terratreats/utils/app_theme.dart";

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
          title: const Text(
            "TerraTreats",
            style: TextStyle(
              backgroundColor: AppTheme.highlight,
              color: AppTheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          backgroundColor: AppTheme.highlight,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _botNavTapped,
          currentIndex: _selectedIndex,
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
        ),
      ),
    );
  }
}
