import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/airtel_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/glo_mobile_data.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/mtn_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/n9mobile_data_model.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';

import '../request.dart';

class MobileDataRepository {
  String? route;
  Map body = {};
  Future<GenericResponse> buyData(NetworkSelector networkSelector,
      BasePackage basePackage, String phoneNumber) async {
    body.addAll({
      "token": await LocalDataStorage.getToken(),
      'uuid': await LocalDataStorage.getUserUUID(),
      "phone": phoneNumber,
      "amount": basePackage.getAmount
    });

    switch (networkSelector) {
      case NetworkSelector.mtn:
        body.addAll(
            {"product_type": (basePackage as MtnMobileDataModel).dataName});
        route = AppRoute.mtnData;
        break;
      case NetworkSelector.glo:
        body.addAll(
            {"product_type": (basePackage as GloMobileDataModel).dataName});
        route = AppRoute.gloData;
        break;
      case NetworkSelector.airtel:
        route = AppRoute.airtelData;
        body.addAll(
            {"product_type": (basePackage as AirtelMobileDataModel).data});
        break;
      case NetworkSelector.n9Mobile:
        body.addAll({"product_type": (basePackage as N9MobileDataModel).data});
        route = AppRoute.etisalatData;
        break;
      default:
        break;
    }

    var responseData = await ServerRequest().postData(path: route, body: body);
    return GenericResponse.fromJson(responseData.data);
  }
}
