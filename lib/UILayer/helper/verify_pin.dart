import 'package:enk_pay_project/UILayer/Screens/general/pin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

verifyPin(BuildContext context, {required VoidCallback onSuccess}) async {
  Navigator.push(
          context, MaterialPageRoute(builder: (_) => const PinScreenPad()))
      .then((v) {
    if (v == true) {
      onSuccess();
    }
  });
}
