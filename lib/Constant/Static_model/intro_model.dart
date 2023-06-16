import 'package:flutter/cupertino.dart';

class IntroModel {
  final String image, title, subTitle;
  final VoidCallback? onTap;
  final bool? newFeature;

  IntroModel({
    required this.image,
    required this.title,
    required this.subTitle,
    this.onTap,
    this.newFeature,
  });
}
