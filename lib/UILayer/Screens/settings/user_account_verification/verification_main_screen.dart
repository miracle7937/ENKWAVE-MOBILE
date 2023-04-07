import 'package:enk_pay_project/DataLayer/controllers/auth_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/widget/verification_widget.dart';
import 'package:flutter/material.dart';

import '../../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../../DataLayer/model/login_response_model.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../AuthScreen/select_verification_method_screen.dart';
import 'bvn_nin_verification_screen.dart';
import 'identity_verification_screen.dart';

class VerificationMainScreen extends StatelessWidget {
  const VerificationMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "Account Verification",
        ),
      ),
      builder: (_) => FutureBuilder<UserData?>(
          future: LocalDataStorage.getUserData(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                AccountVerificationWidget(
                  isVerifyCompleted:
                      snapshot.data?.isPhoneVerificationCompleted(),
                  title: 'Phone Number',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SelectVerificationMethodScreen(
                                  basicPhoneEmailVerification:
                                      BasicPhoneEmailVerification
                                          .forAccountVerification,
                                  forPhone: true,
                                )));
                  },
                ),
                AccountVerificationWidget(
                  isVerifyCompleted:
                      snapshot.data?.isEmailVerificationCompleted(),
                  title: 'Email Address',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SelectVerificationMethodScreen(
                                basicPhoneEmailVerification:
                                    BasicPhoneEmailVerification
                                        .forAccountVerification,
                                forPhone: false,
                              ))),
                ),
                AccountVerificationWidget(
                  isVerifyCompleted: snapshot.data?.isBVNAndNINCompleted(),
                  title: 'BVN / NIN Verification',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BVNandNINVerificationScreen())),
                ),
                AccountVerificationWidget(
                  isVerifyCompleted:
                      snapshot.data?.isIdentificationVerifiedCompleted(),
                  title: 'Identification (NIN,DRIVER’S LICENSE,INT PASSPORT)',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const IdentityVerificationScreen())),
                ),
              ],
            );
          }),
    );
  }
}
