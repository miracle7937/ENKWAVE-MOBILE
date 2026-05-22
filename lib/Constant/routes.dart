class AppRoute {
  static const String _defaultBaseRoute = "https://enkpayapp.enkwave.com/api";
  static String baseRoute = _defaultBaseRoute;

  static void setBaseRoute(String url) {
    var normalized = url.trim();
    if (!normalized.endsWith('/api')) {
      normalized = normalized.replaceAll(RegExp(r'/+$'), '');
      if (!normalized.endsWith('/api')) normalized = '$normalized/api';
    }
    baseRoute = normalized;
  }

  static void resetBaseRoute() {
    baseRoute = _defaultBaseRoute;
  }

  static String get signUp => "$baseRoute/register";
  static String get logINPhone => "$baseRoute/phone-login";
  static String get logINEmail => "$baseRoute/email-login";

  static String get sendOTPPhone => "$baseRoute/verify-phone";
  static String get sendOTPEmil => "$baseRoute/verify-email";
  static String get reSendOTPPhone => "$baseRoute/resend-phone-otp";
  static String get resSendOTPEmil => "$baseRoute/resend-email-otp";
  static String get otpVerificationPhone => "$baseRoute/verify-phone-otp";
  static String get otpVerificationEmail => "$baseRoute/verify-email-otp";
  static String get otpUpdateDevice => "$baseRoute/update-device";
  static String get sendOTPEmailAuthUser => "$baseRoute/auth-verify-email";
  static String get sendOTPPhoneAuthUser => "$baseRoute/auth-verify-phone";

  static String get getAllState => "$baseRoute/get-states";
  static String get getLga => "$baseRoute/get-lga";
  static String get transferProperties => "$baseRoute/transfer-properties";
  static String get verifyAccount => "$baseRoute/resolve-bank";
  static String get verifyBillAccount => "$baseRoute/verify-account";
  static String get transferOfBank => "$baseRoute/bank-transfer";
  static String get getWallet => "$baseRoute/get-wallet";
  static String get selfCashoutProperties => "$baseRoute/selfcashout-properties";
  static String get transactionStatus => "$baseRoute/transaction-status";
  static String get inAppWalletTransfer => "$baseRoute/enkpay-transfer";
  static String get inAppVerifyUserAccount => "$baseRoute/resolve-enkpay-account";
  static String get createdPin => "$baseRoute/account/create-pin";
  static String get verifyPin => "$baseRoute/verify-pin";
  static String get logout => "$baseRoute/logout";
  static String get forgotPin => "$baseRoute/forgot-pin";
  static String get forgotForgot => "$baseRoute/forgot-password";
  static String get updateBusiness => "$baseRoute/update-business";
  static String get orderDevice => "$baseRoute/order-device";
  static String get verifyIdentity => "$baseRoute/verify-identity";
  static String get uploadIdentity => "$baseRoute/upload-identity";
  static String get updateBankInfo => "$baseRoute/update-bank-info";
  static String get getTerminalTransaction => "$baseRoute/get-terminal-transaction";
  static String get getTerminals => "$baseRoute/get-terminals";
  static String get orderDeviceComplete => "$baseRoute/order-device-complete";
  static String get getProfile => "$baseRoute/user-info";
  static String get createAccount => "$baseRoute/create-account";
  static String get createStaticVirtualAccount =>
      "$baseRoute/create-static-virtual-account";
  static String get deleteUser => "$baseRoute/delete-user";
  static String get cashOutRout => "$baseRoute/self-cash-out";
  static String get getHistory => "$baseRoute/all-transaction";
  static String get transactionHistoryByDate => "$baseRoute/transaction-history";
  static String get logDispute => "$baseRoute/log-dispute";
  static String get myDisputes => "$baseRoute/my-disputes";
  static String myDisputeDetail(int id) => "$baseRoute/my-disputes/$id";
  static String myDisputeReply(int id) => "$baseRoute/my-disputes/$id/reply";
  static String get contact => "$baseRoute/contact";
  static String get fundCardRoute => "$baseRoute/fund-card";
  static String get verifyIdentityCardRoute => "$baseRoute/verify-card-identity";
  static String get blockCardRoute => "$baseRoute/block-card";
  static String get unBlockCardRoute => "$baseRoute/unblock-card";
  static String get liquidateCardRoute => "$baseRoute/liquidate-card";
  static String get cardDetails => "$baseRoute/card-details";
  static String get createCard => "$baseRoute/create-card";
  static String get pinLogin => "$baseRoute/pin-login";
  static String get getBeneficiary => "$baseRoute/get-beneficiary";
  static String get deleteBeneficiary => "$baseRoute/delete-beneficiary";
  static String get updateBeneficiary => "$baseRoute/update-beneficiary";

  static const String termsAndCondition = "https://enkwave.com/terms-and-condition";

  static String get billingProducts => "$baseRoute/get-data-plan";
  static String get getCablePlan => "$baseRoute/get-cable-plan";
  static String get buyData => "$baseRoute/buy-data";
  static String get buyAirtime => "$baseRoute/buy-airtime";
  static String get lookUp => "$baseRoute/verify-account";
  static String get electricCompany => "$baseRoute/electric-company";
  static String get buyPower => "$baseRoute/buy-power";

  static const String billBaseRoute = "https://app.enkwave.com/api";
  static String get featuresPermission => "$billBaseRoute/features";
  static String get mtnData => "$billBaseRoute/mtndata";
  static String get gloData => "$billBaseRoute/glodata";
  static String get airtelData => "$billBaseRoute/airteldata";
  static String get etisalatData => "$billBaseRoute/etisalatdata";
  static String get dstv => "$billBaseRoute/dstv";
  static String get goTV => "$billBaseRoute/gotv";
  static String get starTimes => "$billBaseRoute/startimes";

  static String getAirtimeRoute(String route) {
    return "$billBaseRoute/$route";
  }

  static String get tidConfig => "$baseRoute/tid-config";
}
