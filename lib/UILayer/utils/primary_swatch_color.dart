import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class PrimarySwatchColor {
  static MaterialColor get() {
    MaterialColor customPrimaryColor = MaterialColor(
      0xFF990000,
      <int, Color>{
        50: EPColors.appMainColor,
        100: EPColors.appMainColor,
        200: EPColors.appMainColor,
        300: EPColors.appMainColor,
        400: EPColors.appMainColor,
        500: EPColors.appMainColor,
        600: EPColors.appMainColor,
        700: EPColors.appMainColor,
        800: EPColors.appMainColor,
        900: EPColors.appMainColor,
      },
    );
    return customPrimaryColor;
  }
}
