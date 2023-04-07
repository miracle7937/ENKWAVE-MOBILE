import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/Screens/request_device/request_device_main_page.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_bank_info/update_account_information.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/update_pin_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/verification_main_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/setting_tabs.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/verification_widget.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:flutter/material.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/controllers/signup_controller.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../utils/show_alert_dialog.dart';
import 'business_info_screen.dart';
import 'customer_care_screen.dart';

class SettingScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const SettingScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLogout = false;
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
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(EPImages.settingsBg),
                                  fit: BoxFit.cover)),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        // Container(
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.white,
                                        //         borderRadius:
                                        //             BorderRadius.circular(8)),
                                        //     child: InkWell(
                                        //       onTap: () {
                                        //         print(snapshot.data
                                        //             ?.isUserKycCompleted());
                                        //       },
                                        //       child: Padding(
                                        //         padding: const EdgeInsets.all(3.0),
                                        //         child: Row(
                                        //           children: [
                                        //             Text(
                                        //               "Edit",
                                        //               style: Theme.of(context)
                                        //                   .textTheme
                                        //                   .headline1!
                                        //                   .copyWith(
                                        //                       fontWeight:
                                        //                           FontWeight.w400,
                                        //                       color: EPColors
                                        //                           .appGreyColor),
                                        //             ),
                                        //             const Icon(Icons.edit)
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      snapshot.data?.isMale
                                          ? Image.asset(EPImages.userMale)
                                          : Image.asset(
                                              EPImages.female,
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
                                            snapshot.data?.firstName ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color:
                                                        EPColors.appWhiteColor),
                                          ),
                                          Text(
                                            snapshot.data?.addressLine1 ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        EPColors.appWhiteColor),
                                          ),
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
                                              Text(
                                                snapshot.data?.phone ?? "",
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
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            VerificationWidget(
                              isVerifyCompleted:
                                  snapshot.data?.isStatusCompleted(),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const VerificationMainScreen())),
                            )
                          ],
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
              image: EPImages.requestDevice,
              title: "Request for a new device",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RequestDevicePage())),
            ),
            SettingTabs(
              image: EPImages.updateBankAccount,
              title: "Update Account information",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UpdateAccountScreen(
                            refresh: widget.onRefresh,
                          ))),
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
                        SignUpController().logOut().whenComplete(() {
                          setState(() => isLogout = false);
                          LocalDataStorage.clearUser();
                          Navigator.pushNamed(context, "/");
                        }).onError((error, stackTrace) {
                          setState(() => isLogout = false);

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
