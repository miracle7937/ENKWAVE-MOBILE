import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../model/electricity_model/electric_company_model.dart';
import '../model/look_up/lookup_model.dart';
import '../request.dart';

class ElectricityRepository {
  final ServerRequest _serverRequest = ServerRequest();
  Future<ElectricCompanyResponse> getAllCompany() async {
    var responseData = await _serverRequest.getData(
      path: AppRoute.electricCompany,
    );
    return ElectricCompanyResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> buyPower(Map map) async {
    var responseData =
        await _serverRequest.postData(path: AppRoute.buyPower, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<LookupModel> verifyMeterNo(Map<String, dynamic> map) async {
    var response = await ServerRequest()
        .postData(path: AppRoute.verifyBillAccount, body: map);
    return LookupModel.fromJson(response.data);
  }
}
