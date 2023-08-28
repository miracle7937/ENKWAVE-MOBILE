import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../CustomWidget/ReUseableWidget/pin_screen.dart';

class AuthPinScreen extends StatefulWidget {
  const AuthPinScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPinScreen> createState() => _PinBodyState();
}

class _PinBodyState extends State<AuthPinScreen> {
  @override
  Widget build(BuildContext context) {
    return EPScaffold(builder: (context) {
      return SafeArea(
        child: Column(
          children: [
            const Spacer(),
            PinScreenWidget(
                codeLength: 4,
                shuffle: true,
                codeVerify: (code) {
                  return Future.value(true);
                }),
            const Spacer(),
          ],
        ),
      );
    });
  }
}
