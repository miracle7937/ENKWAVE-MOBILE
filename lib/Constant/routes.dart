class AppRoute {
  // static String baseRoute = "https://test.enkpay.com/api";
  static String baseRoute = "https://enkpayapp.enkwave.com/api";

  static String signUp = "$baseRoute/register";
  static String logINPhone = "$baseRoute/phone-login";
  static String logINEmail = "$baseRoute/email-login";

  //oTP
  static String sendOTPPhone = "$baseRoute/verify-phone";
  static String sendOTPEmil = "$baseRoute/verify-email";

  static String reSendOTPPhone = "$baseRoute/resend-phone-otp";
  static String resSendOTPEmil = "$baseRoute/resend-email-otp";

  static String otpVerificationPhone = "$baseRoute/verify-phone-otp";
  static String otpVerificationEmail = "$baseRoute/verify-email-otp";
  static String otpUpdateDevice = "$baseRoute/update-device";

  static String sendOTPEmailAuthUser = "$baseRoute/auth-verify-email";
  static String sendOTPPhoneAuthUser = "$baseRoute/auth-verify-phone";

  static String getAllState = "$baseRoute/get-states";
  static String getLga = "$baseRoute/get-lga";
  static String transferProperties = "$baseRoute/transfer-properties";
  static String verifyAccount = "$baseRoute/resolve-bank";
  static String verifyBillAccount = "$baseRoute/verify-account";

  static String transferOfBank = "$baseRoute/bank-transfer";
  static String getWallet = "$baseRoute/get-wallet";
  static String selfCashoutProperties = "$baseRoute/selfcashout-properties";
  static String transactionStatus = "$baseRoute/transaction-status";

  static String inAppWalletTransfer = "$baseRoute/enkpay-transfer";

  static String inAppVerifyUserAccount = "$baseRoute/resolve-enkpay-account";
  static String createdPin = "$baseRoute/account/create-pin";
  static String verifyPin = "$baseRoute/verify-pin";
  static String logout = "$baseRoute/logout";
  static String forgotPin = "$baseRoute/forgot-pin";
  static String forgotForgot = "$baseRoute/forgot-password";
  static String updateBusiness = "$baseRoute/update-business";
  static String orderDevice = "$baseRoute/order-device";
  static String verifyIdentity = "$baseRoute/verify-identity";
  static String uploadIdentity = "$baseRoute/upload-identity";
  static String updateBankInfo = "$baseRoute/update-bank-info";
  static String getTerminalTransaction = "$baseRoute/get-terminal-transaction";
  static String getTerminals = "$baseRoute/get-terminals";
  static String orderDeviceComplete = "$baseRoute/order-device-complete";
  static String getProfile = "$baseRoute/user-info";
  static String createAccount = "$baseRoute/create-account";
  static String deleteUser = "$baseRoute/delete-user";
  static String cashOutRout = "$baseRoute/self-cash-out";
  static String getHistory = "$baseRoute/all-transaction";
  static String contact = "$baseRoute/contact";
  static String fundCardRoute = "$baseRoute/fund-card";
  static String verifyIdentityCardRoute = "$baseRoute/verify-card-identity";
  static String blockCardRoute = "$baseRoute/block-card";
  static String unBlockCardRoute = "$baseRoute/unblock-card";
  static String liquidateCardRoute = "$baseRoute/liquidate-card";
  static String cardDetails = "$baseRoute/card-details";
  static String createCard = "$baseRoute/create-card";
  static String pinLogin = "$baseRoute/pin-login";

  static String termsAndCondition = "https://enkwave.com/terms-and-condition";

  //data buying and bill

  static String billingProducts = "$baseRoute/get-data-plan";
  static String getCablePlan = "$baseRoute/get-cable-plan";
  static String buyData = "$baseRoute/buy-data";
  static String buyAirtime = "$baseRoute/buy-airtime";
  static String lookUp = "$baseRoute/verify-account";
  static String electricCompany = "$baseRoute/electric-company";
  static String buyPower = "$baseRoute/buy-power";

  static String billBaseRoute = "https://app.enkwave.com/api";
  static String featuresPermission = "$billBaseRoute/features";

  static String mtnData = "$billBaseRoute/mtndata";
  static String gloData = "$billBaseRoute/glodata";
  static String airtelData = "$billBaseRoute/airteldata";
  static String etisalatData = "$billBaseRoute/etisalatdata";

  //cableTV
  static String dstv = "$billBaseRoute/dstv";
  static String goTV = "$billBaseRoute/gotv";
  static String starTimes = "$billBaseRoute/startimes";

  static String getAirtimeRoute(String route) {
    return "$billBaseRoute/$route";
  }
}
