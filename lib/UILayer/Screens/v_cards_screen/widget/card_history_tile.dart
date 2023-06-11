import 'package:enk_pay_project/Constant/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Constant/colors.dart';
import '../../../../DataLayer/model/card_details_model.dart';
import '../../../utils/money_formatter.dart';
import '../../../utils/time_ago_util.dart';

class CardHistoryTile extends StatelessWidget {
  final CardTransaction cardTransaction;
  const CardHistoryTile({Key? key, required this.cardTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          cardTransaction.isDebit()
              ? Image.asset(EPImages.cardDebit)
              : Image.asset(EPImages.cardCredit),
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
                      cardTransaction.cardTransactionType ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: Colors.black, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      amountFormatter(cardTransaction.amount),
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    cardTransaction.description ?? "",
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
                                    cardTransaction.transactionDate),
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
                    // status(context)
                  ],
                ),
                const Divider()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
