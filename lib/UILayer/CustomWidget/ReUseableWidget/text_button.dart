import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class TextClickButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const TextClickButton({Key? key, this.title, this.onTap, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: EPColors.appMainColor,
      onTap: onTap,
      child: Text(
        title ?? "",
        style: textStyle ?? const TextStyle(color: Colors.white),
      ),
    );
  }
}
