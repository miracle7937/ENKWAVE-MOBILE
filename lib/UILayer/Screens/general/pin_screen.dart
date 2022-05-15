import 'package:enk_pay_project/DataLayer/controllers/set_pin_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/pin_screen.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinScreenPad extends StatefulWidget {
  const PinScreenPad({Key? key}) : super(key: key);

  @override
  _PinScreenPadState createState() => _PinScreenPadState();
}

class _PinScreenPadState extends State<PinScreenPad> with VerifyPinView {
  late PinController controller;
  @override
  Widget build(BuildContext context) {
    controller = Provider.of<PinController>(context)..setVerifyPin = this;
    return EPScaffold(
      state: AppState(pageState: controller.pageState),
      builder: (_) => SafeArea(
        child: Column(
          children: [
            const Spacer(),
            PinScreenWidget(
                codeLength: 4,
                shuffle: true,
                codeVerify: (code) {
                  controller.verifyPin = code;
                  return Future.value(true);
                }),
            EPButton(
              onTap: () {
                controller.summitVerifyPin();
              },
              title: 'Summit',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    controller.inputList.clear();
    snackBar(context, message: message);
  }

  @override
  void onSuccess(String message) async {
    print("hee");
    controller.inputList.clear();
    Navigator.pop(context, true);
  }
}
