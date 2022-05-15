import 'package:enk_pay_project/DataLayer/model/feature_permission_model.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/repository/dashboard_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

class DashBoardController with ChangeNotifier {
  UserData userData = UserData();
  FeaturePermissionModel featurePermissionModel = FeaturePermissionModel();
  late DashboardView _dashboardView;
  PageState pageState = PageState.loaded;

  set setView(DashboardView dashboardView) {
    _dashboardView = dashboardView;
  }

  get fullName => "${userData.name}";
  get getAccountBalance => "${userData.accountBalance}";
  bool get isMerchant => !(userData.accountBalance == "user");
  fetchDashboardData() async {
    if (userData.phoneNumber == null || featurePermissionModel.data == null) {
      try {
        pageState = PageState.loading;
        var result = await Future.wait([
          DashboardRepository().fetch(),
          DashboardRepository().dashBoardPermission()
        ]);
        pageState = PageState.loaded;
        notifyListeners();
        userData = (result[0] as LoginResponseModel).data!;
        featurePermissionModel = result[1] as FeaturePermissionModel;
        debugPrint(userData.toJson().toString());
        debugPrint(">>>>>>>>>>>>>>>>>>>feature>>>>>>>>>>>>>>>>>");
        debugPrint(featurePermissionModel.toJson().toString());
      } catch (e) {
        debugPrint(e.toString());
        pageState = PageState.loaded;
        notifyListeners();
        _dashboardView.onError(e.toString());
      }
    }
  }
}

abstract class DashboardView {
  void onSuccess();
  void onError(String message);
}
