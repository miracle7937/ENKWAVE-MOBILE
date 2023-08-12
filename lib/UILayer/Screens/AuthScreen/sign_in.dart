import 'dart:io';

import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/biomertic_controller.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/select_verification_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/package_info.dart';
import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/controllers/signin_controller.dart';
import '../main_screens/nav_ui.dart';
import 'device_reg/change_device_otp.dart';
import 'forget_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with LOGINView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late SignInController authController;
  bool isBiometricEnable = false;

  @override
  void initState() {
    super.initState();
    checkBiometric();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.initCredential();
      credentialInit();
    });
  }

  credentialInit() async {
    UserCredentialModel? _credentialModel =
        await LocalDataStorage.getUserCredential();
    if (_credentialModel != null) {
      onSetUserCredential(_credentialModel);
    }
  }

  checkBiometric() async {
    isBiometricEnable = await BiometricController.isBiometricEnable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    authController = Provider.of<SignInController>(context)..view = this;
    return EPScaffold(
        backgroundColor: Colors.white,
        state: AppState(pageState: authController.pageState),
        scaffoldKey: _scaffoldKey,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            "Welcome back,",
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please sign in.",
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                // MyForm(),
                const SizedBox(
                  height: 35,
                ),
                authController.loginWithPhoneNumber
                    ? EPForm(
                        controller: _phoneController,
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Enter phone number",
                        onChange: (v) {
                          authController.setPhone(v);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.phone,
                      )
                    : Row(
                        children: [
                          Expanded(
                              child: EPForm(
                            controller: _emailController,
                            enabledBorderColor: EPColors.appGreyColor,
                            hintText: "Enter email e.g. enkwave@email.com",
                            onChange: (v) {
                              authController.setEmail(v);
                            },
                          )),
                        ],
                      ),
                EPForm(
                  controller: _passwordController,
                  hintText: "Enter password",
                  enabledBorderColor: EPColors.appGreyColor,
                  forPassword: true,
                  onChange: (v) {
                    authController.setPassword(v);
                  },
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextClickButton(
                      title: "Forget Password",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: EPColors.appMainColor),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgetPasswordScreen()));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                EPButton(
                  title: "LOG IN",
                  onTap: () async {
                    authController.validateSIGNInForm();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EPButtonWithBoarder(
                        title: authController.loginWithPhoneNumber
                            ? "Login with email"
                            : "Login with phone number",
                        onTap: () {
                          credentialInit();
                          authController.setLoginType(
                              !authController.loginWithPhoneNumber);
                        },
                      ),
                      isBiometricEnable
                          ? InkWell(
                              splashColor: EPColors.appMainColor,
                              onTap: () async {
                                // final fcmToken = await FirebaseMessaging.instance.getToken();
                                //
                                // debugPrint(fcmToken);
                                authController.biometricLogin();
                              },
                              child: Image.asset(Platform.isAndroid
                                  ? EPImages.fingerPrint
                                  : EPImages.faceID))
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextClickButton(
                      title: "No Account Yet? ",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              color: EPColors.appGreyColor,
                              fontWeight: FontWeight.w500),
                      onTap: () {},
                    ),
                    TextClickButton(
                      title: "Create your account",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: EPColors.appMainColor),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SelectVerificationMethodScreen()));

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const RegistrationScreen()));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Version  ${PackageInfo().getVersion()}",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        });
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(v) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const NavUI()),
      (route) => false,
    );
  }

  @override
  void onValidate() {
    authController.logIn();
  }

  @override
  void onNewDevice(String message) {
    showChangeDeviceIdDialog(context, message: message, onTap: () {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ChangeDeviceOTPScreen()));
    });
  }

  @override
  void onSetUserCredential(UserCredentialModel userCredentialModel) {
    _emailController.text = userCredentialModel.email ?? "";
    _phoneController.text = userCredentialModel.phone ?? "";
    setState(() {});
  }
}
