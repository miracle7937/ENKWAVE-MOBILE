import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/user_registration_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/model/location_response.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';

class RegistrationScreenAddress extends StatefulWidget {
  const RegistrationScreenAddress({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenAddress> createState() =>
      _PersonalRegistrationAddressState();
}

class _PersonalRegistrationAddressState extends State<RegistrationScreenAddress>
    implements REGAddressView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  late AuthController authController;

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _provider = Provider.of<AuthController>(context, listen: false);
      _provider.setRegAddress = this;
    });
  }

  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context)..getAllLocation();
    return EPScaffold(
        appBar: EPAppBar(
          title: const Text("REGISTRATION"),
        ),
        scaffoldKey: _scaffoldKey,
        // state: AppState(pageState: authController.pageState),
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
                                "Address Information ",
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
                        ],
                      ),
                    ],
                  ),
                  EPDropdownButton<LocationData>(
                      itemsListTitle: "Select State",
                      iconSize: 22,
                      value: authController.location,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item.name!
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        authController.setNGState = v;
                      },
                      items: (authController.locationData ?? [])
                          .map(
                            (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: EPColors.appBlackColor))),
                          )
                          .toList()),
                  EPDropdownButton<String>(
                      itemsListTitle: "Local Government Area",
                      iconSize: 22,
                      value: authController.lgaData,
                      hint: const Text(""),
                      isExpanded: true,
                      underline: const Divider(),
                      searchMatcher: (item, text) {
                        return item
                            .toString()
                            .toLowerCase()
                            .contains(text.toLowerCase());
                      },
                      onChanged: (v) {
                        authController.setLga = v;
                      },
                      items: (authController.allLgaData ?? [])
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
                  EPForm(
                    // controller: addressEditingController,
                    hintText: "Residential/Business Address",
                    onChange: (v) {
                      authController.registrationModel.street = v;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EPButton(
                    loading: authController.pageState == PageState.loading,
                    title: "PROCEED",
                    onTap: () {
                      authController.validateRegistrationAddressForm();
                    },
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  const SizedBox(
                    height: 20,
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
        MaterialPageRoute(builder: (_) => const RegistrationScreenPassword()));
  }
}
