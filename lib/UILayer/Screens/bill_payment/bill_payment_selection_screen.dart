import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/cards_view.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/cable_tv_screen.dart';
import 'package:enk_pay_project/UILayer/utils/screen_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BillPaymentSelection extends StatelessWidget {
  const BillPaymentSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
        appBar: EPAppBar(
          title: Text(
            "Bill payment",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600, color: EPColors.appBlackColor),
          ),
        ),
        builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " What will you like to do?",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: EPColors.appBlackColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                CardSelectCard(
                  image: EPImages.cableTv,
                  title: "Cable TV",
                  onTap: () {
                    pushToNextScreen(context, const CableTVScreen());
                  },
                ),
                CardSelectCard(
                  image: EPImages.educationIcon,
                  title: "Education",
                ),
                CardSelectCard(
                  image: EPImages.electricityIcon,
                  title: "Electricity",
                ),
                CardSelectCard(
                  image: EPImages.bettingIcon,
                  title: "Betting",
                ),
                CardSelectCard(
                  image: EPImages.immigrationIcon,
                  title: "Immgration / FRSC",
                )
              ],
            ));
  }
}
