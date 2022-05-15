import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/create_pin_model.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../request.dart';

class SettingPinRepository {
  //get List of banks
  Future<GenericResponse> createPin(CreatePinModel createPinModel) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.createdPin, body: createPinModel.toJson());
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse2> verifyPin(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.verifyPin, body: map);
    return GenericResponse2.fromJson(responseData.data);
  }
}
