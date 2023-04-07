import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../request.dart';

class MobileDataRepository {
  String? route;
  Map body = {};
  Future<GenericResponse> buyData(Map body) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.buyData, body: body);
    return GenericResponse.fromJson(responseData.data);
  }
}
