import 'package:flutter/material.dart';
import 'package:terratreats/utils/app_theme.dart';

class MyAppBar {
  static AppBar customAppBar({required String title}) {
    return AppBar(
      backgroundColor: AppTheme.highlight,
      title: Text(
        title,
        style: TextStyle(color: AppTheme.primary, fontSize: 20),
      ),
    );
  }
}
