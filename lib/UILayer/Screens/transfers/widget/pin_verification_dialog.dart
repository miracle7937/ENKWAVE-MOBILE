import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../DataLayer/controllers/pin_controller.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../settings/update_pin_screen.dart';

// import 'package:pinput/pinput.dart';

showPinDialog(BuildContext context,
    {required Function(bool, String, String) onVerification}) {
  return pinDialog(context,
      body: _PinBody(
        onVerification: onVerification,
      ));
}

class _PinBody extends StatefulWidget {
  final Function(bool, String, String)? onVerification;

  const _PinBody({
    Key? key,
    required this.onVerification,
  }) : super(key: key);

  @override
  State<_PinBody> createState() => _PinBodyState();
}

class _PinBodyState extends State<_PinBody> with PinView {
  late PinVerificationController pinController;

  @override
  Widget build(BuildContext context) {
    pinController = Provider.of<PinVerificationController>(context)
      ..setView = this;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
            child: Icon(
          Icons.password_outlined,
          size: 40,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Center(
              child: Text(
            "Enter your 4 Digit Transfer Pin",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.grey,
                  fontSize: 18,
                ),
          )),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: PinCodeFields(
              length: 4,
              activeBorderColor: EPColors.appMainColor,
              obscureText: true,
              keyboardType: TextInputType.number,
              onComplete: (pin) => pinController.verifyPin(pin),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        pinController.pageState == PageState.loading
            ? CircularProgressIndicator(
                color: EPColors.appMainColor,
              )
            : Container(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UpdatePinScreen())),
          child: Text("Forgot pin?",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.green,
                    fontSize: 18,
                  )),
        )
      ],
    );
  }

  @override
  onError(String message) {
    widget.onVerification!(false, message, pinController.pin!);
  }

  @override
  onSuccess(String message) {
    widget.onVerification!(true, message, pinController.pin!);
  }
}
