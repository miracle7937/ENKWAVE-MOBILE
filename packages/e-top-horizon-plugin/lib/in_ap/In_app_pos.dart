import 'package:flutter/material.dart';

import '../../screens/amount_pad_screen.dart';
import '../etop_pos_plugin.dart';
import '../screens/EOD/eod_screen.dart';
import '../screens/in_app_money_pad.dart';
import '../utils/transaction_type.dart';

class InAppPOS {
  start(BuildContext context, {Map? terminalInfo, String? userID}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PosAmountScreen(
                  transactionType: TransactionType.purchase,
                  onSelectAmount: (amount) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InAppPOSAccountSelectionScreen(
                                  onSelectAccountType: (accountType) {
                                    var data = {
                                      "amount": amount,
                                      "accountType": accountType,
                                    };
                                    EtopPosPlugin()
                                        .pay(terminalInfo!..addAll(data));
                                  },
                                )));
                  },
                )));
  }

  eodView(
      {required BuildContext context,
      required String userId,
      required String baseURl}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EODScreen(
                  userID: userId,
                  baseUrl: baseURl,
                )));
  }
}
