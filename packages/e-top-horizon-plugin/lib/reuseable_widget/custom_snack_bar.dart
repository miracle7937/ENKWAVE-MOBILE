import 'package:flutter/material.dart';

import '../constant/color.dart';

customSnackBar(BuildContext context, {String? message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: EPColors.appMainColor,
      content: Text(message!),
      duration: const Duration(seconds: 2),
    ),
  );
}
