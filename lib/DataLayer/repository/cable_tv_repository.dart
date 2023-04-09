import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/UILayer/utils/cable_tv_enum.dart';

import '../request.dart';

class CableTvRepository {
  String? route;
  Map body = {};
  Future<GenericResponse> processCablePayment(CableEnum cableEnum,
      String package, String smartcardno, String phoneNumber) async {
    body.addAll({
      "token": await LocalDataStorage.getToken(),
      'uuid': await LocalDataStorage.getUserUUID(),
      "phone": phoneNumber,
      "package": package,
      "smartcardno": smartcardno,
    });

    switch (cableEnum) {
      case CableEnum.dsTv:
        body.addAll({"cabletv": "dstv"});
        route = AppRoute.dstv;
        break;
      case CableEnum.goTv:
        body.addAll({"cabletv": "gotv"});
        route = AppRoute.goTV;
        break;
      case CableEnum.startTimes:
        route = AppRoute.starTimes;
        body.addAll({"cabletv": "startimes"});
        break;

      default:
        break;
    }
    var responseData = await ServerRequest().postData(path: route, body: body);
    return GenericResponse.fromJson(responseData.data);
  }
}
