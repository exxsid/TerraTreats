import "package:flutter/material.dart";
import "package:terratreats/utils/app_theme.dart";

class MyParcel extends StatefulWidget {
  const MyParcel({super.key});

  @override
  State<MyParcel> createState() => _MyParcelState();
}

class _MyParcelState extends State<MyParcel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: AppTheme.highlight,
        height: double.infinity,
        child: Text("My Parcel screen"),
      ),
    );
  }
}
