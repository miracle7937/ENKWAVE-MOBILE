import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/look_data.dart';
import 'package:enk_pay_project/DataLayer/model/look_up/lookup_model.dart';

import '../request.dart';

class LookUPRepository {
  final ServerRequest _serverRequest = ServerRequest();
  Future<LookupModel> byAirTime(LookData lookData) async {
    var responseData = await _serverRequest.postData(
        path: AppRoute.lookUp, body: lookData.toJson());
    return LookupModel.fromJson(responseData.data);
  }
}
