import 'dart:async';

import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/otp_verification_countdown.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../../DataLayer/model/login_response_model.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class ChangeDeviceOTPScreen extends StatefulWidget {
  const ChangeDeviceOTPScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeDeviceOTPScreen> createState() => _ChangeDeviceOTPScreenState();
}

class _ChangeDeviceOTPScreenState extends State<ChangeDeviceOTPScreen>
    with OTPView {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool sendToken = false;
  late CountdownOTP _countdownOTP;
  UserData? userData;
  @override
  void initState() {
    textEditingController = TextEditingController();
    _countdownOTP = CountdownOTP(countSec: 60);
    errorController = StreamController<ErrorAnimationType>();
    getUserData();
    super.initState();
  }

  getUserData() async {
    userData = await LocalDataStorage.getUserData();
    setState(() {});
  }

  @override
  void dispose() {
    errorController!.close();
    _countdownOTP.dispose();
    super.dispose();
  }

  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)..otpView = this;

    return EPScaffold(
      appBar: EPAppBar(
        iconTheme: IconThemeData(color: EPColors.appWhiteColor),
        title: const Text('Verification'),
      ),
      builder: (_) => GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Email Verification',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code sent to  ",
                    children: [
                      TextSpan(
                        text: userData?.email ?? "",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,

                      pastedTextStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold),

                      length: 4,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,

                      validator: (v) {
                        if (v!.length < 3) {
                          return null;
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        errorBorderColor: Colors.white,
                        selectedColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: EPColors.appWhiteColor,
                        disabledColor: Colors.white,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        authController.setOTp(v);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                    // style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  StreamBuilder<String?>(
                      stream: _countdownOTP.timerStream,
                      builder: (_, snap) => TextButton(
                          onPressed: () {
                            snap.hasData
                                ? null
                                : authController.resendOTPForDeviceID();
                          },
                          child: Text(
                            snap.hasData ? (snap.data.toString()) : "SEND CODE",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color: EPColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                          )))
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              EPButton(
                loading: authController.pageState == PageState.loading
                    ? true
                    : false,
                title: "VERIFY".toUpperCase(),
                onTap: () {
                  formKey.currentState!.validate();
                  // conditions for validating
                  if (currentText.length < 4) {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  } else {
                    authController.otpVerificationAndDeviceUpdate();
                    setState(
                      () {
                        hasError = false;
                      },
                    );
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(String message) {
    errorController!.add(ErrorAnimationType.shake);
    snackBar(context, message: message, forError: true);
  }

  @override
  void onSuccess(String message) {
    _countdownOTP.count();
    snackBar(context, message: "OTP resend!!");
  }

  @override
  void onVerify(String message) async {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
