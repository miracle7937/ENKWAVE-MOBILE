import 'dart:io';

import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/Screens/airtime_screen/buy_airtime_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/bill_payment_selection_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/data_screen/buy_data_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:telpo_pos_enkwave/telpo_pos_enkwave.dart';

import '../../../DataLayer/model/login_response_model.dart';
import '../../../services/service_initialization.dart';

class DashBoardBuilder {
  static List<IntroModel> builder(
      APPPermission? appPermission, BuildContext context) {
    List<IntroModel> dashBoardData = [];
    if ((Platform.isAndroid && appPermission?.pos == 1) ||
        DeviceServiceInit.androidInfo?.model == DeviceServiceInit.telpoDevice) {
      dashBoardData.add(IntroModel(
        title: "POS",
        subTitle: "Cash in instantly with MPOS/POS",
        image: EPImages.posIcon,
        onTap: () {
          TelpoPosEnkwave().epSDKInit(amount: "100", accountType: "01");
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) => const PosAmountScreen()));
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
