import 'package:enk_pay_project/Constant/routes.dart';

import '../request.dart';

class PackageRepository {
  final ServerRequest _serverRequest = ServerRequest();

  Future<Map> getPackage() async {
    var responseData =
        await _serverRequest.getData(path: AppRoute.billingProducts);
    return responseData.data;
  }

  Future<Map> getCablePackage() async {
    var responseData =
        await _serverRequest.getData(path: AppRoute.getCablePlan);
    return responseData.data;
  }
}
