import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/text_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool forEmail = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   child: Image.asset(
        //     // Images.auth_Bg,
        //     fit: BoxFit.cover,
        //     width: MediaQuery.of(context).size.width,
        //   ),
        // ),
        EPScaffold(
            scaffoldKey: _scaffoldKey,
            // backgroundColor: Colors.white,
            // backgroundColor: Colors.transparent,
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
                    forEmail
                        ? EPForm(
                            controller: _emailController,
                            enabledBorderColor: EPColors.appGreyColor,
                            hintText: "Enter email e.g. enkwave@email.com",
                            onChange: (v) {},
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: EPForm(
                                  controller: _phoneController,
                                  enabledBorderColor: EPColors.appGreyColor,
                                  hintText: "Enter phone number",
                                  onChange: (v) {},
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
                      onChange: (v) {},
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    EPButton(
                      title: "LOG IN",
                      onTap: () {},
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
                            title: !forEmail
                                ? "Login with email"
                                : "Login with phone number",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: EPColors.appGreyColor,
                                    fontWeight: FontWeight.w500),
                            onTap: () {
                              setState(() {
                                forEmail = !forEmail;
                              });
                            },
                          ),
                          InkWell(
                              splashColor: EPColors.appMainColor,
                              onTap: () {},
                              child: Image.asset(EPImages.fingerPrint)),
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
                      onTap: () {},
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
}
