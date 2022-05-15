class AppRoute {
  static String baseRoute = "https://auth.enkwave.com/public/api";

  static String signUp = "$baseRoute/auth/register";
  static String logIN = "$baseRoute/auth/login";

  //oTP
  static String sendOTP = "$baseRoute/auth/register/send-verification";
  static String otpVerification = "$baseRoute/register/verify";

  static String listOfBank = "$baseRoute/account/banks";
  static String transferOfBank = "$baseRoute/account/transaction/transfer";
  static String inAppWalletTransfer =
      "$baseRoute/account/transaction/wallet/transfer";
  static String inAppVerifyUser =
      "$baseRoute/account/transaction/wallet/verify-user";
  static String createdPin = "$baseRoute/account/create-pin";
  static String verifyPin = "$baseRoute/account/verify-pin";
  static String getProfile = "$baseRoute/account/profile";
  static String termsAndCondition = "https://enkwave.com/terms-and-condition";

  //data buying and bill
  static String billBaseRoute = "https://app.enkwave.com/api";
  static String featuresPermission = "$billBaseRoute/features";
  static String billingProducts = "$billBaseRoute/billingProducts";

  static String mtnData = "$billBaseRoute/mtndata";
  static String gloData = "$billBaseRoute/glodata";
  static String airtelData = "$billBaseRoute/airteldata";
  static String etisalatData = "$billBaseRoute/etisalatdata";

  static String getAirtimeRoute(String route) {
    return "$billBaseRoute/$route";
  }
}
