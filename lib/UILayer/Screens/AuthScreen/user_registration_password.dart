import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/set_pin_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:enk_pay_project/UILayer/utils/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class RegistrationScreenPassword extends StatefulWidget {
  const RegistrationScreenPassword({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenPassword> createState() =>
      _PersonalRegistrationPasswordState();
}

class _PersonalRegistrationPasswordState
    extends State<RegistrationScreenPassword> implements REGPasswordView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)
      ..setRegPassword = this;
    return EPScaffold(
        appBar: EPAppBar(
          title: const Text("REGISTRATION"),
        ),
        scaffoldKey: _scaffoldKey,
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
                                "Set Password ",
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
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
                      authController.registrationModel.passwordConfirmation = v;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EPButton(
                    loading: PageState.loading == authController.pageState,
                    title: "PROCEED".toUpperCase(),
                    onTap: () {
                      authController.validateRegistrationPasswordForm();
                    },
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                ],
              ),
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
  void onFormValid() {
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SetPinScreen()))
        .then((value) {
      if (value == true) {
        onRegister();
      }
    });
  }

  @override
  void onRegister() {
    authController.register();
  }

  @override
  void onSuccess(String message) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => StatusScreen(
                  title: message,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ), (r) {
                      return false;
                    });
                  },
                )));
    authController.clearFormAfterRegistration();
  }
}
