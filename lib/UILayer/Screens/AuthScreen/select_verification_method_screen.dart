import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/user_registration_personal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/auth_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import 'otp_screen.dart';

class SelectVerificationMethodScreen extends StatefulWidget {
  const SelectVerificationMethodScreen({
    Key? key,
  }) : super(key: key);

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
    return DefaultTabController(
      length: 2,
      child: EPScaffold(
        padding: EdgeInsets.zero,
        state: AppState(
          pageState: authController!.pageState,
        ),
        appBar: EPAppBar(
          iconTheme: IconThemeData(color: EPColors.appWhiteColor),
          title: const Text("VERIFICATION"),
        ),
        builder: (_) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: EPColors.appMainColor,
                child: IgnorePointer(
                  child: TabBar(
                    onTap: (i) {
                      authController?.setIsVerificationPhone(
                          !authController!.isSelectPhoneVerification);
                    },
                    indicatorColor: EPColors.appMainLightColor,
                    tabs: const [
                      Tab(
                        text: "Phone Verification",
                      ),
                      Tab(
                        text: "Email Verification",
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    authController!.isSelectPhoneVerification
                        ? EPForm(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
              )
            ],
          ),
        ),
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
    if (authController!.isSelectPhoneVerification == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const RegistrationScreenPersonalInfo()));
    } else {
      authController?.sendOTP();
    }
    //when phone otp is done it can now be change  to only authController?.sendOTP(); for both phone and email
  }
}
