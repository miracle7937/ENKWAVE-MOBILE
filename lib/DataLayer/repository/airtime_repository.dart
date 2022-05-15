import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/airtime_model.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';

class AirTimeRepository {
  final ServerRequest _serverRequest = ServerRequest();
  Future<GenericResponse> byAirTime(
      AirtimeModel airtimeModel, NetworkSelector selector) async {
    var responseData = await _serverRequest.postData(
        path: AppRoute.getAirtimeRoute(getAirtelRoute(selector)),
        body: airtimeModel.toJson());
    return GenericResponse.fromJson(responseData.data);
  }
}
