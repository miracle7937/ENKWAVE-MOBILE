import 'dart:math';

import 'package:flutter/material.dart';

class EPColors {
  static Color appMainColor = const Color(0XFFfb6514);
  // static Color appMainColor = const Color(0XFF673E66);
  static Color appMainLightColor = const Color(0XFFfb6514).withOpacity(0.3);
  static Color appGreyColor = Colors.grey;
  static Color appWhiteColor = Colors.white;
  static Color appBlackColor = Colors.black;

  //bill color
  static Color mtnColor = const Color(0XFFe6d305);
  static Color gloColor = const Color(0XFF65ff24);
  static Color airtelColor = const Color(0XFFd91c1c);
  static Color i9mobile = const Color(0XFF000000);
  static Color dsTv = const Color(0XFF03a5fc);

  static Color generateRandomColor() {
    Random random = Random();
    Color color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    return color;
  }
}
