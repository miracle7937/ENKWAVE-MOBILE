import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  NoData(
    this.message, {
    this.child,
    Key? key,
    this.size = 18,
  });

  final Widget? child;
  final String message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child ??
          Text(
            message,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
    );
  }
}
