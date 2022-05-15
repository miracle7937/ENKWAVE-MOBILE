import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_user_response_model.dart';

import '../request.dart';

class TransferRepository {
  //get List of banks
  Future<ListOfBanks> fetchListOfBanks() async {
    var responseData = await ServerRequest().getData(path: AppRoute.listOfBank);
    return ListOfBanks.fromJson(responseData.data);
  }

  Future bankTransfer(BankTransferModel bankTransferModel) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.transferOfBank, body: bankTransferModel.toJson());
    return;
  }

  Future<GenericResponse2> inAppTransfer(InAppModelData inAppModelData) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.inAppWalletTransfer, body: inAppModelData.toJson());
    return GenericResponse2.fromJson(responseData.data);
  }

  Future<InAppUserResponseModel> inAppVerifyUser(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.inAppVerifyUser, body: map);
    return InAppUserResponseModel.fromJson(responseData.data);
  }
}
