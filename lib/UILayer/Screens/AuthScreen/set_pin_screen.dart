import 'package:enk_pay_project/DataLayer/controllers/set_pin_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/pin_screen.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/auth_controller.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({Key? key}) : super(key: key);

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> with OnSetPin {
  late PinController setPinController;
  @override
  Widget build(BuildContext context) {
    setPinController = Provider.of<PinController>(context)..setView = this;
    AuthController authController = Provider.of<AuthController>(context);
    return EPScaffold(
      builder: (_) => Column(
        children: [
          const Spacer(),
          PinScreenWidget(
            title: 'Set Your Transaction Pin'.toUpperCase(),
            codeVerify: (v) {
              setPinController.setPin(v);
              setPinController.inputList.clear();
              return Future.value(true);
            },
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }

  @override
  void onEnterPin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ConfirmPinScreen()));
  }

  @override
  void onSuccess() {
    // TODO: implement onSuccess
  }
}

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({Key? key}) : super(key: key);

  @override
  _ConfirmPinScreenState createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen>
    with OnConfirmPinView {
  late PinController setPinController;
  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    setPinController = Provider.of<PinController>(context)
      ..setConfirmView = this;
    authController = Provider.of<AuthController>(context);

    return EPScaffold(
      builder: (_) => Column(
        children: [
          const Spacer(),
          PinScreenWidget(
            title: 'Confirm Your Transaction Pin'.toUpperCase(),
            codeVerify: (v) {
              setPinController.setConfirmPin = v;
              setPinController.inputList.clear();
              return Future.value(true);
            },
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }

  @override
  void onSuccess() {
    authController.registrationModel.pin = setPinController.pin;
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  void onEnterConfirmPin() {}

  @override
  void onPinNotConfirmed(String message) {
    snackBar(context, message: message);
  }
}
