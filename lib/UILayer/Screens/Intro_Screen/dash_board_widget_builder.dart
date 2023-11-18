import 'dart:developer';

import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/UILayer/Screens/airtime_screen/buy_airtime_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/bill_payment_selection_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/data_screen/buy_data_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_main_screen.dart';
import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/material.dart';

import '../../../DataLayer/LocalData/local_data_storage.dart';
import '../../../DataLayer/model/login_response_model.dart';
import '../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../pos_screens/accountype_selection.dart';
import '../pos_screens/pos_amount_screen.dart';
import '../v_cards_screen/loader_page.dart';
import '../v_cards_screen/v_card_request_screen.dart';
import '../v_cards_screen/v_card_screen.dart';

class DashBoardBuilder {
  static List<IntroModel> builder(
      APPPermission? appPermission, BuildContext context) {
    List<IntroModel> dashBoardData = [];
    if (appPermission?.pos == 0) {
      dashBoardData.add(IntroModel(
        title: "POS",
        subTitle: "Cash in instantly with MPOS/POS",
        image: EPImages.posIcon,
        onTap: () async {
          NavigatorState navigator = Navigator.of(context);
          navigator.push(MaterialPageRoute(
              builder: (_) => PosAmountScreen(
                    onAmount: (String? amount) {
                      Navigator.of(context).pop();
                      if (isNotEmpty(amount)) {
                        log(amount.toString());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (a) => AccountTypeSelectionScreen(
                                  onSelectAccountType: (String tanxType) async {
                                    log(tanxType.toString());
                                    Navigator.of(context).pop();
                                    UserData? userData =
                                        await LocalDataStorage.getUserData();
                                    TerminalConfig? terminalConfig =
                                        await LocalDataStorage
                                            .getTerminalConfig();
                                    if (userData?.isStatusCompleted() == true) {
                                      Map data = {
                                        "customerName": userData
                                            ?.terminalInfo?.merchantName,
                                        "userID": userData?.id,
                                        "phoneNumber": userData?.phone ?? "",
                                        "email": userData?.email ?? "",
                                        "tid":
                                            userData?.terminalInfo?.terminalNo,
                                        "amount": amount,
                                        "accountType": tanxType,
                                        "tid_config": terminalConfig?.toJson()
                                      };
                                      await EtopPosPlugin().pay(data);
                                    } else {
                                      snackBar(context,
                                          message:
                                              "We kindly request you to complete your KYC");
                                    }
                                  },
                                )));
                      }
                    },
                  )));
        },
      ));
    }
    if (appPermission?.bankTransfer == 1) {
      dashBoardData.add(
        IntroModel(
            title: "Transfer",
            subTitle: "Instant Bank transfer",
            image: EPImages.transferIcon,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TransfersMainScreen()));
            }),
      );
    }

    if (appPermission?.bills == 1) {
      dashBoardData.add(
        IntroModel(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BillPaymentSelection()));
            },
            title: "Pay Bills",
            subTitle: "Pay all local bills instantly",
            image: EPImages.payBill),
      );
    }
    if (appPermission?.mobileData == 1) {
      dashBoardData.add(
        IntroModel(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BuyDataScreen()));
            },
            title: "Buy Data",
            subTitle: "Buy data instantly all network available",
            image: EPImages.byData),
      );
    }
    if (appPermission?.airtime == 1) {
      dashBoardData.add(
        IntroModel(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BuyAirtimeScreen()));
            },
            title: "Buy Airtime",
            subTitle: "Buy Airtime instantly all network available",
            image: EPImages.byAirtime),
      );
    }
    if (appPermission?.vcard == 1) {
      dashBoardData.add(IntroModel(
        newFeature: true,
        title: "Virtual Card",
        subTitle: "Get a virtual card to make online purchase",
        image: EPImages.vCard,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LoaderPage(
                        onChange: (value) async {
                          if (value == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const VCardScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const VCardRequestScreen()));
                          }
                        },
                      )));
        },
      ));
    }
    if (appPermission?.insurance == 1) {
      dashBoardData.add(
        IntroModel(
            title: "Insurance",
            subTitle: "Get all kind of insurance",
            image: EPImages.insurance),
      );
    }
    if (appPermission?.education == 1) {
      dashBoardData.add(
        IntroModel(
            title: "Exam Cards",
            subTitle: "Buy WAEC, NECO, NYSC etc cards",
            image: EPImages.examCard),
      );
    }
    if (appPermission?.ticket == 1) {
      dashBoardData.add(
        IntroModel(
            title: "Buy Ticket",
            subTitle: "Buy affordable flight Ticket",
            image: EPImages.flightTicket),
      );
    }
    if (appPermission?.exchange == 1) {
      dashBoardData.add(IntroModel(
          title: "Exchange",
          subTitle: "Exchange your currency seamless ",
          image: EPImages.forex));
    }

    return dashBoardData;
  }
}
