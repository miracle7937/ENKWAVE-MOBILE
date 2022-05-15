import 'dart:io';

import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/model/feature_permission_model.dart';
import 'package:enk_pay_project/UILayer/Screens/airtime_screen/buy_airtime_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/bill_payment/bill_payment_selection_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/data_screen/buy_data_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/pos_screens/pos_amount_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/transfer_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoardBuilder {
  static List<IntroModel> builder(
      PermissionModelData permissionModelData, BuildContext context) {
    List<IntroModel> dashBoardData = [];
    if (Platform.isAndroid && permissionModelData.pos == true) {
      dashBoardData.add(IntroModel(
        title: "POS",
        subTitle: "Cash in instantly with MPOS/POS",
        image: EPImages.posIcon,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PosAmountScreen()));
        },
      ));
    }
    if (permissionModelData.transfer == true) {
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

    if (permissionModelData.payBills == true) {
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
    if (true) {
      dashBoardData.add(
        IntroModel(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BuyDataScreen()));
            },
            title: "Buy Data",
            subTitle: "Buy data instantly all network available",
            image: EPImages.byData),
      );
    }
    if (permissionModelData.buyAirtime == true) {
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
    if (permissionModelData.insurance == true) {
      dashBoardData.add(
        IntroModel(
            title: "Insurance",
            subTitle: "Get all kind of insurance",
            image: EPImages.insurance),
      );
    }
    if (permissionModelData.examCard == true) {
      dashBoardData.add(
        IntroModel(
            title: "Exam Cards",
            subTitle: "Buy WAEC, NECO, NYSC etc cards",
            image: EPImages.examCard),
      );
    }
    if (permissionModelData.flight == true) {
      dashBoardData.add(
        IntroModel(
            title: "Buy Ticket",
            subTitle: "Buy affordable flight Ticket",
            image: EPImages.flightTicket),
      );
    }
    if (permissionModelData.exchange == true) {
      dashBoardData.add(IntroModel(
          title: "Exchange",
          subTitle: "Exchange your currency seamless ",
          image: EPImages.forex));
    }

    return dashBoardData;
  }
}
