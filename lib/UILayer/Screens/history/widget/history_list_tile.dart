import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constant/colors.dart';
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
        child: Row(
          children: [
            HistoryIcon(
              transactionEnum:
                  getTransactionEnum(transactionData!.transactionType!),
            ),
            // const Icon(Icons.doorbell),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        transactionData?.title ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.black, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        amountFormatter(transactionData?.amount.toString()),
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      transactionData?.note ?? "",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: EPColors.appBlackColor,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Row(
                    children: [
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
                                  TimeUtilAgo.format(
                                      transactionData!.createdAt!),
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
                      ),
                      const Spacer(),
                      status(context, transactionData?.status)
                    ],
                  ),
                  const Divider()
                ],
              ),
            ),
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

  String statusString(num? status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Successful";
      default:
        return "Reversed";
    }
  }

  Color statusColor(num? status) {
    switch (status) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  status(BuildContext context, num? status) {
    return Container(
      decoration: BoxDecoration(
          color: statusColor(status), borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(
          child: Text(
            statusString(status),
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
