import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future pushToNextScreen(BuildContext context, Widget widget) async {
  // debugPrint("Moving to ${widget.toString()} ");
  Navigator.push(context, MaterialPageRoute(builder: (_) => widget));

  // return data;
}

/// Pops every route above the home shell (e.g. after bank transfer success).
void popToHome(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
