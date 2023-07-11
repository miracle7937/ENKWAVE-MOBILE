import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/user_account_verification/widget/identy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/controllers/account_verification_controller.dart';
import '../../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class BVNandNINVerificationScreen extends StatefulWidget {
  const BVNandNINVerificationScreen({Key? key}) : super(key: key);

  @override
  State<BVNandNINVerificationScreen> createState() =>
      _BVNandNINVerificationScreenState();
}

class _BVNandNINVerificationScreenState
    extends State<BVNandNINVerificationScreen> with VerificationView {
  AccountVerificationController? verificationController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    verificationController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    verificationController = Provider.of<AccountVerificationController>(context)
      ..setView(this);
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text("VERIFY BVN"),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Verify your BVN",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // EPDropdownButton<VerificationType>(
          //     itemsListTitle: "Select Mode of Verification",
          //     iconSize: 22,
          //     value: verificationController?.verificationType,
          //     hint: const Text(""),
          //     isExpanded: true,
          //     underline: const Divider(),
          //     searchMatcher: (item, text) {
          //       return item.name.toLowerCase().contains(text.toLowerCase());
          //     },
          //     onChanged: (v) {
          //       verificationController?.setVerificationType(v);
          //       setState(() {});
          //     },
          //     items: (VerificationType.values)
          //         .map(
          //           (e) => DropdownMenuItem(
          //             value: e,
          //             child: Text(e.name.toUpperCase().toString(),
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .headline3!
          //                     .copyWith(
          //                         fontWeight: FontWeight.bold,
          //                         color: EPColors.appBlackColor)),
          //           ),
          //         )
          //         .toList()),
          EPForm(
            hintText: "Enter your BVN",
            enabledBorderColor: EPColors.appGreyColor,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.digitsOnly
            ],
            onChange: (v) {
              verificationController?.setVerificationValue = v;
            },
          ),
          IdentityWidget(
            image: verificationController?.yourImage,
            title: "Upload a passport",
            subTitle: "Choose a clear photo of yourself",
            onTap: () {
              verificationController?.setYourImage();
            },
          ),
          EPButton(
            loading: PageState.loading == verificationController?.pageState,
            title: "OK",
            onTap: () => verificationController?.onSummit(),
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

  @override
  onFormVerify() {
    verificationController?.verifyData();
  }
}
