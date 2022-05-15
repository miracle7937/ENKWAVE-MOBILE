import 'dart:async';

import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:enk_pay_project/UILayer/utils/otp_verification_countdown.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final RegistrationResponse? response;
  const OTPScreen({Key? key, this.response}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with OTPView {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool sendToken = false;
  late CountdownOTP _countdownOTP;
  @override
  void initState() {
    textEditingController = TextEditingController();
    _countdownOTP = CountdownOTP(countSec: 60);
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _countdownOTP.dispose();
    super.dispose();
  }

  // snackBar Widget

  @override
  Widget build(BuildContext context) {
    AuthController authController = Provider.of<AuthController>(context)
      ..otpView = this;
    return EPScaffold(
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
                  'Phone Number Verification',
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
                        text: "widget.response!.data!.phoneNumber",
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

                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Fill all form";
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
                            snap.hasData ? null : authController.sendOTP();
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
                  if (currentText.length != 4 || currentText != "1234") {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  } else {
                    authController.otpVerification();
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
    snackBar(context, message: message);
  }

  @override
  void onSuccess(String message) {
    _countdownOTP.count();
    snackBar(context, message: "OTP resend!!");
  }

  @override
  void onVerify(String message) async {
    snackBar(context, message: message);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SignInScreen()));
  }
}
