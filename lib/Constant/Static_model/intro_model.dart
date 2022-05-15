import 'package:flutter/cupertino.dart';

class IntroModel {
  final String image, title, subTitle;
  final VoidCallback? onTap;

  IntroModel({
    required this.image,
    required this.title,
    required this.subTitle,
    this.onTap,
  });
}
