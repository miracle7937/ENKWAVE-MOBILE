import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/UILayer/Screens/request_device/request_device_main_page.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_bank_info/update_account_information.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_pin_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/verification_main_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/setting_tabs.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/verification_widget.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/controllers/signin_controller.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../utils/show_alert_dialog.dart';
import '../../utils/sync_keys.dart';
import 'business_info_screen.dart';
import 'customer_care_screen.dart';
import 'manage_terminals/manage_terminals_screen.dart';

class SettingScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const SettingScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLogout = false;
  bool isDeleteAccount = false;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh!();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<UserData?>(
                future: LocalDataStorage.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: LoaderWidget(),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {},
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          snapshot.data?.isMale == true
                                              ? Image.asset(
                                                  EPImages.userMale,
                                                  width: 30,
                                                )
                                              : Image.asset(
                                                  EPImages.female,
                                                  width: 30,
                                                ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${snapshot.data?.firstName ?? ""}  ${snapshot.data?.lastName ?? ""} ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: EPColors
                                                            .appWhiteColor),
                                              ),
                                              snapshot.data?.addressLine1 !=
                                                      null
                                                  ? Text(
                                                      snapshot.data
                                                              ?.addressLine1 ??
                                                          "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: EPColors
                                                                  .appWhiteColor),
                                                    )
                                                  : Container(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    snapshot.data?.email ?? "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: EPColors
                                                                .appWhiteColor),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              isNotEmpty(
                                                      snapshot.data?.serialNo)
                                                  ? Text(
                                                      "Terminal NO: ${snapshot.data?.serialNo ?? ""}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: EPColors
                                                                  .appWhiteColor),
                                                    )
                                                  : Container(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        VerificationWidget(
                          isVerifyCompleted: snapshot.data?.isStatusCompleted(),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const VerificationMainScreen()));
                            widget.onRefresh!();
                          },
                        )
                      ],
                    ),
                  );
                }),
            SettingTabs(
              image: EPImages.changePinIcon,
              title: "Change transfer pin",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UpdatePinScreen())),
            ),
            SettingTabs(
              image: EPImages.businessInfoIcon,
              title: "Business information",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BusinessInfoScreen())),
            ),
            SettingTabs(
                image: EPImages.syncKey,
                title: "Sync terminal keys",
                onTap: () async {
                  SyncKeys().init(context);
                }),
            SettingTabs(
              image: EPImages.requestDevice,
              title: "Request for a new device",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RequestDevicePage())),
            ),
            SettingTabs(
              image: EPImages.updateBankAccount,
              title: "Update Bank Account information",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UpdateAccountScreen(
                            refresh: widget.onRefresh,
                          ))),
            ),
            SettingTabs(
              image: EPImages.manageTerminal,
              title: "Manage Terminals",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManageTerminalScreen())),
            ),
            SettingTabs(
              image: EPImages.customerCare,
              title: "Contact customer care",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CustomerCareScreen())),
            ),
            isLogout == false
                ? SettingTabs(
                    image: EPImages.logOut,
                    title: "Log out",
                    onTap: () {
                      showAlertDialog(context,
                          message: "Are You sure you want to logout?",
                          onTap: () {
                        Navigator.pop(context);
                        setState(() => isLogout = true);
                        SignInController().logOut().whenComplete(() {
                          setState(() => isLogout = false);
                          LocalDataStorage.clearUser();
                          Navigator.pushNamed(context, "/");
                          //dispose dashboard controller to clear a valeus
                          Provider.of<DashBoardController>(context,
                                  listen: false)
                              .clearAll();
                        }).onError((error, stackTrace) {
                          setState(() => isLogout = false);
                          Provider.of<DashBoardController>(context,
                                  listen: false)
                              .clearAll();
                          LocalDataStorage.clearUser();
                          Navigator.pushNamed(context, "/");
                        });
                      });
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 18),
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          color: EPColors.appMainColor,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
            isDeleteAccount == false
                ? SettingTabs(
                    image: EPImages.deleteAccount,
                    title: "Delete Account",
                    onTap: () {
                      showAlertDialog(context,
                          message:
                              "Are You sure you want to delete your account?",
                          onTap: () {
                        Navigator.pop(context);
                        setState(() => isDeleteAccount = true);
                        SignInController().deleteAccount().then((value) {
                          //if request is true delete account
                          if (value == true) {
                            setState(() => isDeleteAccount = false);
                            LocalDataStorage.clearUser();
                            Navigator.pushNamed(context, "/");
                            Provider.of<DashBoardController>(context,
                                    listen: false)
                                .clearAll();
                          }
                        }).onError((error, stackTrace) {
                          setState(() => isDeleteAccount = false);
                          Provider.of<DashBoardController>(context,
                                  listen: false)
                              .clearAll();
                          LocalDataStorage.clearUser();
                          Navigator.pushNamed(context, "/");
                        });
                      });
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 18),
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          color: EPColors.appMainColor,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
