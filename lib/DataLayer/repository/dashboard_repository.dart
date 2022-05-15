import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/feature_permission_model.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';

import '../request.dart';

class DashboardRepository {
  Future<LoginResponseModel> fetch() async {
    var responseData = await ServerRequest().getData(path: AppRoute.getProfile);
    return LoginResponseModel.fromJson(responseData.data);
  }

  Future<FeaturePermissionModel> dashBoardPermission() async {
    var responseData =
        await ServerRequest().getData(path: AppRoute.featuresPermission);
    return FeaturePermissionModel.fromJson(responseData.data);
  }
}
