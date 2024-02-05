import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../model/api_property_model.dart';
import '../model/service_look_up_response.dart';
import '../request.dart';

class ApiServiceRepository {
  Future<ApiServiceProperty> fetchTransferProperties() async {
    var responseData = await ServerRequest().getData(path: AppRoute.apiService);
    return ApiServiceProperty.fromJson(responseData.data);
  }

  Future<ServiceLookUResponse> serviceCheck(Map body) async {
    var responseData =
        await ServerRequest().postData(body: body, path: AppRoute.serviceCheck);
    return ServiceLookUResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> serviceFund(Map body) async {
    var responseData =
        await ServerRequest().postData(body: body, path: AppRoute.serviceFund);
    return GenericResponse.fromJson(responseData.data);
  }
}
