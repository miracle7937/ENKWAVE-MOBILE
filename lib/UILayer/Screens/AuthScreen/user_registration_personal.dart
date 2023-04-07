import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/user_registration_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';

class RegistrationScreenPersonalInfo extends StatefulWidget {
  const RegistrationScreenPersonalInfo({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenPersonalInfo> createState() =>
      _PersonalRegistrationState();
}

class _PersonalRegistrationState extends State<RegistrationScreenPersonalInfo>
    implements REGPersonalView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)
      ..setRegPersonal = this;
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
                                "Personal Information",
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
                      authController.registrationModel.lastName = v;
                    },
                    enabledBorderColor: EPColors.appGreyColor,
                    hintText: "Last Name",
                  ),
                  EPDateForm(
                    hintText: "Date Of Birth",
                    onChange: (v) {
                      authController.registrationModel.dob = v;
                    },
                  ),
                  // EPForm(
                  //   hintText: "Enter email address",
                  //   enabledBorderColor: EPColors.appGreyColor,
                  //   onChange: (v) {
                  //     authController.registrationModel.email = v;
                  //   },
                  //   keyboardType: TextInputType.emailAddress,
                  // ),
                  // EPForm(
                  //   hintText: "Enter phone number",
                  //   enabledBorderColor: EPColors.appGreyColor,
                  //   onChange: (v) {
                  //     authController.registrationModel.phone = v;
                  //   },
                  //   keyboardType: TextInputType.phone,
                  // ),
                  EPDropdownButton<String>(
                      itemsListTitle: "Gender",
                      iconSize: 22,
                      value: authController.registrationModel.gender,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.toLowerCase().contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        authController.setGender = v;
                      },
                      items: ["Male", "Female"]
                          .map(
                            (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: EPColors.appBlackColor))),
                          )
                          .toList()),
                  const SizedBox(
                    height: 10,
                  ),
                  EPButton(
                    title: "PROCEED".toUpperCase(),
                    onTap: () {
                      authController.validateRegistrationPersonalForm();
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
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const RegistrationScreenAddress()));
  }
}
