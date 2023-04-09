import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/email_phone_verification_controller.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'otp_verification.dart';

class EmailPhoneVerification extends StatefulWidget {
  final bool forPhone;
  const EmailPhoneVerification({Key? key, this.forPhone = true})
      : super(key: key);

  @override
  State<EmailPhoneVerification> createState() => _EmailPhoneVerificationState();
}

class _EmailPhoneVerificationState extends State<EmailPhoneVerification>
    with RequestOTPView {
  EmailPhoneVerificationController? controller;
  @override
  Widget build(BuildContext context) {
    controller = Provider.of<EmailPhoneVerificationController>(context)
      ..setIsPhoneVerification(widget.forPhone)
      ..requestOTPView = this;
    return EPScaffold(
      state: AppState(pageState: controller!.pageState),
      appBar: EPAppBar(
        iconTheme: IconThemeData(color: EPColors.appWhiteColor),
        title: const Text("VERIFICATION"),
      ),
      builder: (_) => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          controller!.isSelectPhoneVerification
              ? EPForm(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  key: const ValueKey("Enter Phone  Number"),
                  hintText: "Enter Phone  Number",
                  onChange: (v) {
                    controller?.setPhone(v);
                  },
                )
              : EPForm(
                  key: const ValueKey("Enter Email"),
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter Email",
                  onChange: (v) {
                    controller?.setEmail(v);
                  },
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          EPButton(
            title: "Continue",
            onTap: () {
              controller?.validateRequestOTPForm();
            },
          )
        ],
      ),
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(String message) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const OTPEmailPhoneScreen()));
  }

  @override
  void onFormValid() {
    controller?.sentAuthUserOTP();
  }
}
