import 'dart:math';

import 'package:enk_pay_project/Constant/Static_model/intro_model.dart';
import 'package:enk_pay_project/Constant/image.dart';

String generateRandomString(int length) {
  var rand = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rand.nextInt(chars.length))));
}

String listOfStringToFormattedString(List data) {
  return data[0].toString();
  // return data.join("\n\n");
}

String removeAllWhitespace(String value) {
  return value.replaceAll(' ', '');
}

class ConstantString {
  static List<IntroModel> introItems = [
    IntroModel(
        title: "POS TRANSACTION",
        subTitle: "Accept payment easily with your mobile phone",
        image: EPImages.bg1),
    IntroModel(
        title: "AIRTIME & DATA BUNDLE",
        subTitle: "Purchase all networks airtime and data bundle ",
        image: EPImages.bg2),
    IntroModel(
        title: "BILL PAYMENTS",
        subTitle: "Pay all bill payment with ease",
        image: EPImages.bg3),
    IntroModel(
        title: "MONEY TRANSFER",
        subTitle: "Transfer money to all local banks",
        image: EPImages.bg4),
  ];

  static List<IntroModel> dashBoardData = [
    IntroModel(
        title: "POS",
        subTitle: "Cash in instantly with MPOS/POS",
        image: EPImages.posIcon),
    IntroModel(
        title: "Transfer",
        subTitle: "Instant Bank transfer",
        image: EPImages.transferIcon),
    IntroModel(
        title: "Pay Bills",
        subTitle: "Pay all local bills instantly",
        image: EPImages.payBill),
    IntroModel(
        title: "Buy Data",
        subTitle: "Buy data instantly all network availlable",
        image: EPImages.byData),
    IntroModel(
        title: "Buy Airtime",
        subTitle: "Buy Airtime insantly all network available",
        image: EPImages.byAirtime),
    IntroModel(
        title: "Insurance",
        subTitle: "Get all kind of insurance",
        image: EPImages.insurance),
    IntroModel(
        title: "Exam Cards",
        subTitle: "Buy WAEC, NECO, NYSC etc cards",
        image: EPImages.examCard),
    IntroModel(
        title: "Buy Ticket",
        subTitle: "Buy affordable flight Ticket",
        image: EPImages.flightTicket),
    IntroModel(
        title: "Exchange",
        subTitle: "Exchange your currency seamsley ",
        image: EPImages.forex),
  ];

  static String userDataKey = "user-data-key";
  static String terminalConfig = "terminalConfig";
  static String hideBalance = "hideBalance";
  static String hideBonus = "hideBonus";
  static String enableBiometric = "enableBiometric";
  static String credential = "user-data-credential";
  static String userPermission = "userPermission";
  static String appSettings = "Settings";
}

/// Returns [true] if [s] is either null or empty.
bool isEmpty(String? s) => s == null || s == 'null' || s.trim().isEmpty;

/// Returns [true] if [s] is a not null or empty string.
bool isNotEmpty(String? s) => s != null && s != 'null' && s.trim().isNotEmpty;

String requestTitle =
    "Card creation charge is 2USD \n\n1% transaction fee  min of 1USD and max of 5USD  \n\n 1USD   maintenance fee per active card. \n\n Maximum cash a card can hold is USD 10,000.";

String verifyImageTitle =
    "Take a clear picture of your face Make sure you are not wearing cap to glasses ";
