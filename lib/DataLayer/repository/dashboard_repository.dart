import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';

import '../model/bank_list_response.dart';
import '../model/history_model.dart';
import '../model/wallet_charge_model.dart';
import '../request.dart';

class DashboardRepository {
  Future<LoginResponseModel> fetch() async {
    var responseData = await ServerRequest().getData(path: AppRoute.getProfile);
    return LoginResponseModel.fromJson(responseData.data);
  }

  Future<HistoryModel> getHistory() async {
    var responseData = await ServerRequest().getData(path: AppRoute.getHistory);
    return HistoryModel.fromJson(responseData.data);
  }

  Future<HistoryModel> getHistoryByDate(
      {required String startDate, required String endDate}) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.transactionHistoryByDate,
        body: {"startDate": startDate, "endDate": endDate});
    return HistoryModel.fromJson(responseData.data);
  }

  Future<GenericResponse> createAccount() async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.createAccount);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<WalletChargeModel> getWalletCharge() async {
    var responseData = await ServerRequest().getData(
      path: AppRoute.selfCashoutProperties,
    );
    return WalletChargeModel.fromJson(responseData.data);
  }

  Future<List<UserWallet>> getWallet() async {
    var responseData = await ServerRequest().getData(
      path: AppRoute.getWallet,
    );
    if (responseData.data["status"] == false) {
      return <UserWallet>[];
    } else {
      return (responseData.data["account"] as List)
          .map((e) => UserWallet.fromJson(e))
          .toList();
    }
  }

  Future<GenericResponse> cashOut(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.cashOutRout, body: map);
    return GenericResponse.fromJson(responseData.data);
  }
}
