import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future pushToNextScreen(BuildContext context, Widget widget) async {
  // debugPrint("Moving to ${widget.toString()} ");
  Navigator.push(context, MaterialPageRoute(builder: (_) => widget));

  // return data;
}
