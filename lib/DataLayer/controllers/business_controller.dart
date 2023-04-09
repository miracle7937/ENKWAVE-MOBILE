import 'package:flutter/cupertino.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../model/business_model.dart';
import '../repository/set_pin_repository.dart';

class BusinessController extends ChangeNotifier {
  String? _email;
  PageState pageState = PageState.loaded;
  BusinessView? _businessView;
  BusinessModel businessModel = BusinessModel();

  set setBusinessView(v) {
    _businessView = v;
  }

  setBusiness(String v) {
    _email = v;
  }

  updateBusiness() {
    if (!businessModel.isValid()) {
      print(businessModel.toJson());
      _businessView?.onError("Please ensure all fields are provided");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    SettingPinRepository().businessUpdate(businessModel.toJson()).then((value) {
      if (value.status == true) {
        _businessView?.onSuccess(value.message ?? "");
      } else {
        _businessView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _businessView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }
}

abstract class BusinessView {
  onSuccess(String massage);
  onError(String massage);
}
