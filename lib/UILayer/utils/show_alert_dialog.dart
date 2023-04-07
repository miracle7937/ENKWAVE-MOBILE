import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/colors.dart';

showAlertDialog(
  BuildContext context, {
  String? message,
  VoidCallback? onTap,
  VoidCallback? onRejected,
}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("NOTICE"),
            content: Text(message!),
            actions: <Widget>[
              CupertinoDialogAction(
                textStyle: TextStyle(color: EPColors.appMainColor),
                isDefaultAction: true,
                onPressed: onTap,
                child: const Text("Yes"),
              ),
              CupertinoDialogAction(
                textStyle: TextStyle(color: EPColors.appMainColor),
                onPressed: onRejected ?? () => Navigator.pop(context),
                child: const Text("No"),
              )
            ],
          ));
}
