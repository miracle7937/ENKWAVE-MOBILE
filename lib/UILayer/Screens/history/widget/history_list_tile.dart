import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../DataLayer/model/history_model.dart';
import '../../../utils/money_formatter.dart';
import '../../../utils/time_ago_util.dart';
import 'history_icons.dart';

class HistoryListTile extends StatelessWidget {
  final TransactionData? transactionData;
  final VoidCallback? onTap;
  const HistoryListTile({Key? key, this.transactionData, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                HistoryIcon(
                  transactionEnum:
                      getTransactionEnum(transactionData!.transactionType!),
                ),
                // const Icon(Icons.doorbell),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionData?.title ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: Colors.black, fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.clock,
                                color: Colors.white,
                                size: 10,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                TimeUtilAgo.format(transactionData!.createdAt!),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amountFormatter(transactionAmount(transactionData!)),
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    status(context)
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  String transactionAmount(TransactionData v) {
    if (v.credit == 0) {
      return v.debit.toString();
    }
    return v.credit.toString();
  }

  status(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(
          child: Text(
            "Successful",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}
