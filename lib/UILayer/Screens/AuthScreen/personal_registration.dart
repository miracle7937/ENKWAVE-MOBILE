import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/otp_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:flutter/material.dart';

class PersonalRegistration extends StatefulWidget {
  const PersonalRegistration({Key? key}) : super(key: key);

  @override
  State<PersonalRegistration> createState() => _PersonalRegistrationState();
}

class _PersonalRegistrationState extends State<PersonalRegistration> {
  bool checkedTermsCondition = false;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.01,
          child: Image.asset(
            EPImages.authBg,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        EPScaffold(
            scaffoldKey: _scaffoldKey,
            backgroundColor: Colors.white,
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
                                width: MediaQuery.of(context).size.width * .5,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    "Get started on ENKPAY ",
                                    maxLines: 2,
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
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      EPForm(
                        controller: _emailController,
                        onChange: (v) {
                          // registrationController.registerUserContent.email = v;
                        },
                        hintText: "First Name",
                        enabledBorderColor: EPColors.appGreyColor,
                      ),
                      EPForm(
                        controller: _emailController,
                        onChange: (v) {
                          // registrationController.registerUserContent.email = v;
                        },
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Middle Name",
                      ),
                      EPForm(
                        controller: _emailController,
                        onChange: (v) {
                          // registrationController.registerUserContent.email = v;
                        },
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Last Name",
                      ),
                      EPForm(
                        controller: _emailController,
                        onChange: (v) {
                          // registrationController.registerUserContent.email = v;
                        },
                        enabledBorderColor: EPColors.appGreyColor,
                        hintText: "Enter Email",
                      ),
                      EPForm(
                        controller: _phoneController,
                        hintText: "Enter phone number",
                        enabledBorderColor: EPColors.appGreyColor,
                        onChange: (v) {},
                        keyboardType: TextInputType.phone,
                      ),
                      EPForm(
                        controller: _passwordController,
                        hintText: "Enter password",
                        enabledBorderColor: EPColors.appGreyColor,
                        forPassword: true,
                        onChange: (v) {},
                      ),
                      EPForm(
                        controller: _passwordController,
                        hintText: "Confirm password",
                        enabledBorderColor: EPColors.appGreyColor,
                        forPassword: true,
                        onChange: (v) {},
                      ),
                      // CXForm(
                      //   labelText: "Referral ID",
                      //   hintText: "Enter referral ID",
                      //   onChange: (v) {
                      //     registrationController.registerUserContent.referralId = v;
                      //   },
                      // ),
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
                                  value: checkedTermsCondition,
                                  onChanged: (v) {},
                                  activeColor: EPColors.appGreyColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "I have read and agreed to Terms and Privacy policy",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      EPButton(
                        title: "Create Account".toUpperCase(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const OTPScreen()));
                        },
                      ),
                      const SizedBox(
                        height: 61,
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
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
