import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/cards_view.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_in_app.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_to_other_bank.dart';
import 'package:enk_pay_project/UILayer/utils/screen_navigation.dart';
import 'package:flutter/material.dart';

class TransfersMainScreen extends StatelessWidget {
  const TransfersMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text(
          "Transfer",
        ),
      ),
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "What will you like to do?",
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontWeight: FontWeight.w500, color: EPColors.appBlackColor),
            ),
            const SizedBox(
              height: 15,
            ),
            CardSelectCard(
              image: EPImages.bankTransfer,
              title: "Transfer to other banks",
              onTap: () async {
                await pushToNextScreen(context, const TransferToOtherBank());
              },
            ),
            CardSelectCard(
              image: EPImages.inAppTransfer,
              title: "Transfer to Enkpay users",
              onTap: () async {
                await pushToNextScreen(context, const TransferInApp());
              },
            ),
          ],
        );
      },
    );
  }
}
