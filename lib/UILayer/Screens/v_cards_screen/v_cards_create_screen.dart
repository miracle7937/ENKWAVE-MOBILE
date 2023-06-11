import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/vcard_controller.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';

class VCardCreateScreen extends StatefulWidget {
  const VCardCreateScreen({Key? key}) : super(key: key);

  @override
  State<VCardCreateScreen> createState() => _VCardCreateScreenState();
}

class _VCardCreateScreenState extends State<VCardCreateScreen>
    with OnCreateVCard {
  @override
  Widget build(BuildContext context) {
    VCardController vCardController = Provider.of<VCardController>(context)
      ..setCreateVCardView(this);
    return EPScaffold(
      state: AppState(pageState: vCardController.pageState),
      appBar: EPAppBar(
        title: const Text("Verify"),
      ),
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "Create  your virtual USD card",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(EPImages.epCardView),
            Text(
              "Card creation charge is USD ${vCardController.cardDetailsResponse?.creationCharge}",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            const Spacer(
              flex: 2,
            ),
            Text(
              "Total Amount (NGN)",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Text(
              amountFormatterWithoutDecimal(vCardController.creationFeeNaira()),
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            EPButton(
              title: "Continue",
              onTap: () {
                vCardController.createCard();
              },
            ),
            const Spacer(),
          ],
        ),
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
      Navigator.pop(context);
    });
  }
}
