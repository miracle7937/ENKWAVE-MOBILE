import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/otp_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/terms_and_condition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _PersonalRegistrationState();
}

class _PersonalRegistrationState extends State<RegistrationScreen>
    with AuthView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)..view = this;
    return Stack(
      children: [
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            EPImages.bgShadow,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        EPScaffold(
            scaffoldKey: _scaffoldKey,
            backgroundColor: Colors.transparent,
            state: AppState(pageState: authController.pageState),
            builder: (context) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * .5,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    "Get started on ENKPAY ",
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please sign up.",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      EPForm(
                        onChange: (v) {
                          authController.registrationModel.firstName = v;
                        },
                        hintText: "First Name",
                        enabledBorderColor: EPColors.appGreyColor,
                      ),
                      EPForm(
                        onChange: (v) {
                          authController.registrationModel.middleName = v;
                        },
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Middle Name",
                      ),
                      EPForm(
                        onChange: (v) {
                          authController.registrationModel.lastName = v;
                        },
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Last Name",
                      ),
                      EPForm(
                        hintText: "Enter email address",
                        enabledBorderColor: EPColors.appGreyColor,
                        onChange: (v) {
                          authController.registrationModel.email = v;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      EPForm(
                        hintText: "Enter phone number",
                        enabledBorderColor: EPColors.appGreyColor,
                        onChange: (v) {
                          authController.registrationModel.phone = v;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      EPForm(
                        hintText: "Enter password",
                        enabledBorderColor: EPColors.appGreyColor,
                        forPassword: true,
                        onChange: (v) {
                          authController.registrationModel.password = v;
                        },
                      ),
                      EPForm(
                        hintText: "Confirm password",
                        enabledBorderColor: EPColors.appGreyColor,
                        forPassword: true,
                        onChange: (v) {
                          authController
                              .registrationModel.passwordConfirmation = v;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Theme(
                                data: ThemeData(
                                    primarySwatch: Colors.yellow,
                                    unselectedWidgetColor:
                                        EPColors.appGreyColor),
                                child: Checkbox(
                                  value: authController.checkedTermsCondition,
                                  onChanged: (v) {
                                    authController.setTermsCondition(v!);
                                  },
                                  activeColor: EPColors.appMainColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Text(
                                  "I have read and agreed to ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TermsAndCondition())),
                                  child: Text(
                                    "Terms and Privacy policy",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EPButton(
                        title: "Create Account".toUpperCase(),
                        onTap: () {
                          authController.validateRegistrationForm();
                        },
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextClickButton(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                        },
                        title: "Already signed up? SIgn in",
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
  void onSuccess(RegistrationResponse? response) {
    if (response!.data != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => OTPScreen(
                    response: response,
                  )));
    }
  }

  @override
  void onValidate() {
    authController.register();
  }
}
