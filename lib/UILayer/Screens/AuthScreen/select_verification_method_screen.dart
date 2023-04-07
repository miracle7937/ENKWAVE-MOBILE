import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/auth_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import 'otp_screen.dart';

class SelectVerificationMethodScreen extends StatefulWidget {
  final BasicPhoneEmailVerification? basicPhoneEmailVerification;
  final bool? forPhone;

  const SelectVerificationMethodScreen(
      {Key? key, this.basicPhoneEmailVerification, this.forPhone})
      : super(key: key);

  @override
  State<SelectVerificationMethodScreen> createState() =>
      _SelectVerificationMethodScreenState();
}

class _SelectVerificationMethodScreenState
    extends State<SelectVerificationMethodScreen> with RequestOTPView {
  bool isSelectPhone = true;
  AuthController? authController;
  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)
      ..requestOTPView = this;
    if (BasicPhoneEmailVerification.forAccountVerification ==
        widget.basicPhoneEmailVerification) {
      authController
          ?.setBasicPhoneEmailVerification(widget.basicPhoneEmailVerification);
      authController?.isSelectPhoneVerification = widget.forPhone!;
    }
    return EPScaffold(
      state: AppState(pageState: authController!.pageState),
      appBar: EPAppBar(
        iconTheme: IconThemeData(color: EPColors.appWhiteColor),
        title: const Text("VERIFICATION"),
      ),
      builder: (_) => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BasicPhoneEmailVerification.forAccountVerification ==
                  authController?.basicPhoneEmailVerification
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      child: EPButton(
                        title: "USE PHONE",
                        onTap: () {
                          authController?.setIsVerificationPhone(true);
                        },
                      ),
                    ),
                    Expanded(
                      child: EPButtonWithBoarder(
                        title: "USE EMAIL",
                        onTap: () {
                          authController?.setIsVerificationPhone(false);
                        },
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          authController!.isSelectPhoneVerification
              ? EPForm(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  key: const ValueKey("Enter Phone  Number"),
                  hintText: "Enter Phone  Number",
                  onChange: (v) {
                    authController?.setPhone(v);
                  },
                )
              : EPForm(
                  key: const ValueKey("Enter Email"),
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter Email",
                  onChange: (v) {
                    authController?.setEmail(v);
                  },
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          EPButton(
            title: "Continue",
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => const OTPScreen()));
              // return;
              authController?.validateRequestOTPForm();
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
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const OTPScreen()));
  }

  @override
  void onFormValid() {
    authController?.sendOTP();
  }
}
