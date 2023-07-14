import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/cards/grey_bg_card.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataLayer/controllers/transfer_controller.dart';
import '../../utils/money_formatter.dart';

class TransferPreview extends StatelessWidget {
  const TransferPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransferController _controller = Provider.of<TransferController>(context);

    return EPScaffold(
        appBar: EPAppBar(
          title: const Text(
            "Transfer preview",
          ),
        ),
        builder: (_) => Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GreyBGCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(EPImages.amount),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Amount",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                          const Spacer(),
                          Text(
                            amountFormatter(
                                _controller.bankTransferModel.amount),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(EPImages.totalAmount),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Charges",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                          const Spacer(),
                          Text(
                            amountFormatter(
                                _controller.getTransferCharge().toString()),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: EPColors.appBlackColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Spacer(),
                EPButton(
                  title: "Continue",
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ));
  }
}
