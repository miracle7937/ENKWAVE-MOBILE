import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/business_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({Key? key}) : super(key: key);

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen>
    with BusinessView {
  @override
  Widget build(BuildContext context) {
    Provider.of<BusinessController>(context).setBusinessView = this;
    return EPScaffold(
        state: AppState(
            pageState: Provider.of<BusinessController>(context).pageState),
        appBar: EPAppBar(
          title: const Text("BUSINESS INFO"),
        ),
        builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Provide business information",
                  style: TextStyle(
                    color: EPColors.appBlackColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                EPForm(
                  enabledBorderColor: EPColors.appGreyColor,
                  hintText: "Business Name",
                  onChange: (v) {
                    Provider.of<BusinessController>(context, listen: false)
                        .businessModel
                        .name = v;
                  },
                  keyboardType: TextInputType.text,
                ),
                EPForm(
                  enabledBorderColor: EPColors.appGreyColor,
                  hintText: "Business Address",
                  onChange: (v) {
                    Provider.of<BusinessController>(context, listen: false)
                        .businessModel
                        .address = v;
                  },
                  keyboardType: TextInputType.text,
                ),
                EPForm(
                  enabledBorderColor: EPColors.appGreyColor,
                  hintText: "Business Registered No",
                  onChange: (v) {
                    Provider.of<BusinessController>(context, listen: false)
                        .businessModel
                        .number = v;
                  },
                  keyboardType: TextInputType.text,
                ),
                EPButton(
                  onTap: () =>
                      Provider.of<BusinessController>(context, listen: false)
                          .updateBusiness(),
                  title: "Continue",
                )
              ],
            ));
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
