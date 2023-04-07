import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/custom_form.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/profile_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class UpdatePinScreen extends StatefulWidget {
  const UpdatePinScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePinScreen> createState() => _UpdatePinScreenState();
}

class _UpdatePinScreenState extends State<UpdatePinScreen> with ForgetPinView {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ProfileController>(context)
      ..setForgetPinView(this);

    return EPScaffold(
      state: AppState(pageState: controller.pageState),
      appBar: EPAppBar(
        title: const Text("Change Pin"),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Update your 4 digit pin",
            style: TextStyle(
              color: EPColors.appBlackColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          EPForm(
            enabledBorderColor: EPColors.appGreyColor,
            hintText: "Enter email",
            onChange: (v) {
              controller.setEmail(v);
            },
            keyboardType: TextInputType.emailAddress,
          ),
          EPButton(
            onTap: () => controller.forgetPin(),
            title: "Continue",
          )
        ],
      ),
    );
  }

  @override
  onError(String massage) {
    showEPStatusDialog(context, success: false, message: massage, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  onSuccess(String massage) {
    showEPStatusDialog(context, success: true, message: massage, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
