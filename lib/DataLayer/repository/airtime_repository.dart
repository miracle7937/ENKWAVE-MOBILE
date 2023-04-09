import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/request.dart';

import '../model/bank_list_response.dart';

class AirTimeRepository {
  final ServerRequest _serverRequest = ServerRequest();
  Future<GenericResponse> byAirTime(Map body) async {
    var responseData =
        await _serverRequest.postData(path: AppRoute.buyAirtime, body: body);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<List<UserWallet>> getWallet() async {
    var responseData = await _serverRequest.getData(
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
}
