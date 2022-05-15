import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/biomertic_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/user_registration.dart';
import 'package:enk_pay_project/UILayer/Screens/main_screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with AuthView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthController authController;
  bool isBiometricEnable = false;

  @override
  void initState() {
    super.initState();
    checkBiometric();
  }

  checkBiometric() async {
    isBiometricEnable = await BiometricController.isBiometricEnable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)..view = this;
    return Stack(
      children: [
        Opacity(
          opacity: 1,
          child: Image.asset(
            EPImages.bgShadow,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        EPScaffold(
            backgroundColor: Colors.transparent,
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
                    const SizedBox(
                      height: 35,
                    ),
                    authController.loginWithEmail
                        ? EPForm(
                            controller: _emailController,
                            enabledBorderColor: EPColors.appGreyColor,
                            hintText: "Enter email e.g. enkwave@email.com",
                            onChange: (v) {
                              authController.setEmail(v);
                            },
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: EPForm(
                                  controller: _phoneController,
                                  enabledBorderColor: EPColors.appGreyColor,
                                  hintText: "Enter phone number",
                                  onChange: (v) {
                                    authController.setPhoneConfirmation(v);
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
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
                    const SizedBox(
                      height: 30,
                    ),
                    EPButton(
                      title: "LOG IN",
                      onTap: () {
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
                          TextClickButton(
                            title: !authController.loginWithEmail
                                ? "Login with email"
                                : "Login with phone number",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: EPColors.appGreyColor,
                                    fontWeight: FontWeight.w500),
                            onTap: () {
                              authController.setLoginType =
                                  !authController.loginWithEmail;
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
                                  child: Image.asset(EPImages.fingerPrint))
                              : Container(),
                          TextClickButton(
                            title: "Forgot password?",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: EPColors.appGreyColor,
                                    fontWeight: FontWeight.w500),
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextClickButton(
                      title: "Create your account",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontWeight: FontWeight.w500),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegistrationScreen()));
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(v) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  void onValidate() {
    authController.logIn();
  }
}
