import 'package:flutter/material.dart';

class LoadingIndicator {
  static Container circularLoader() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
