import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

snackBar(BuildContext context, {String? message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: EPColors.appMainColor,
      content: Text(message!),
      duration: const Duration(seconds: 2),
    ),
  );
}
