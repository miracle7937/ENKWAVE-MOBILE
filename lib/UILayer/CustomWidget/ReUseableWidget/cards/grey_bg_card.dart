import 'package:flutter/material.dart';

class GreyBGCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  const GreyBGCard({Key? key, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
      decoration: BoxDecoration(
          color: color ?? Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
