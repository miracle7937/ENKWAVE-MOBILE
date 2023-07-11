import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/widget/identy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/account_verification_controller.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({Key? key}) : super(key: key);

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen>
    with IdentityView {
  AccountVerificationController? accountVerificationController;

  @override
  void dispose() {
    super.dispose();
    accountVerificationController?.clearImage();
  }

  @override
  Widget build(BuildContext context) {
    accountVerificationController =
        Provider.of<AccountVerificationController>(context)
          ..setIdentityView(this);
    return EPScaffold(
      state: AppState(pageState: accountVerificationController?.pageState),
      appBar: EPAppBar(
        title: const Text("IDENTITY VERIFICATION"),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Verify Document",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          IdentityWidget(
            image: accountVerificationController?.billImage,
            title: "Upload a valid Utility bill not less than 3 months",
            subTitle: "Such as PHCN Receipt, Waste Bill Receipt etc",
            onTap: () {
              accountVerificationController?.setUtilityBill();
            },
          ),
          IdentityWidget(
            image: accountVerificationController?.govIDCard,
            title: "Upload a valid government ID Card",
            subTitle: "Such as Driver’s License, Voter’s Card, Int’l Passport",
            onTap: () {
              accountVerificationController?.setGovIDCard();
            },
          ),
          // IdentityWidget(
          //   image: accountVerificationController?.yourImage,
          //   title: "Upload a passport",
          //   subTitle: "Choose a clear photo of yourself",
          //   onTap: () {
          //     accountVerificationController?.setYourImage();
          //   },
          // ),
          EPButton(
            title: "CONTINUE",
            onTap: () {
              accountVerificationController?.uploadImages();
            },
          )
        ],
      ),
    );
  }

  @override
  onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
