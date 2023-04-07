import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_user_response_model.dart';

import '../model/account_verification_model.dart';
import '../model/wallet_model_response.dart';
import '../request.dart';

class TransferRepository {
  //get List of banks
  Future<TransferProperties> fetchTransferProperties() async {
    var responseData =
        await ServerRequest().getData(path: AppRoute.transferProperties);
    return TransferProperties.fromJson(responseData.data);
  }

  Future<GenericResponse> bankTransfer(
      BankTransferModel bankTransferModel) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.transferOfBank, body: bankTransferModel.toJson());
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse2> inAppTransfer(InAppModelData inAppModelData) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.inAppWalletTransfer, body: inAppModelData.toJson());
    return GenericResponse2.fromJson(responseData.data);
  }

  Future<InAppUserResponseModel> inAppVerifyUser(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.inAppVerifyUserAccount, body: map);
    return InAppUserResponseModel.fromJson(responseData.data);
  }

  static Future<AccountVerificationResponse> verifyBankAccount(
      Map<String, dynamic> map) async {
    var response =
        await ServerRequest().postData(path: AppRoute.verifyAccount, body: map);
    return AccountVerificationResponse.fromJson(response.data);
  }

  Future<UserWalletResponse> getWallet() async {
    var responseData = await ServerRequest().getData(
      path: AppRoute.getWallet,
    );

    return UserWalletResponse.fromJson(responseData.data);
  }
}
