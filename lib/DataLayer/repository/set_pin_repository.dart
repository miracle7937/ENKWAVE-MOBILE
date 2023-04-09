import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../request.dart';

class SettingPinRepository {
  Future<GenericResponse2> verifyPin(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.verifyPin, body: map);
    return GenericResponse2.fromJson(responseData.data);
  }

  Future<GenericResponse> forgetPin(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.forgotPin, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> businessUpdate(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.updateBusiness, body: map);
    return GenericResponse.fromJson(responseData.data);
  }
}
