import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/airtime_model.dart';
import 'package:enk_pay_project/DataLayer/repository/airtime_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/cupertino.dart';

class AirtimeController with ChangeNotifier {
  late AirtimeView _view;
  PageState pageState = PageState.loaded;
  late NetworkSelector airTimeRouteSelector;
  AirtimeModel airtimeModel = AirtimeModel();
  setView(AirtimeView view) async {
    _view = view;
    airtimeModel.token = await LocalDataStorage.getToken();
    airtimeModel.uuid = await LocalDataStorage.getUserUUID();
  }

  set setPhone(String v) {
    airtimeModel.phone = v;
  }

  set setAirtimeType(NetworkSelector value) {
    airTimeRouteSelector = value;
  }

  set setAmount(String v) {
    airtimeModel.amount = v;
  }

  onSummit() {
    if (isNotEmpty(airtimeModel.phone)) {
      _view.onPreView();
    } else {
      _view.onError("All fields  must be selected");
    }
  }

  buyAirtel() {
    pageState = PageState.loading;
    notifyListeners();
    AirTimeRepository()
        .byAirTime(airtimeModel, airTimeRouteSelector)
        .then((value) {
      pageState = PageState.loaded;
      notifyListeners();
      if (value.status != true) {
        _view.onError(value.message!);
      } else {
        _view.onSuccess(value.message!);
      }
    }).catchError((error) {
      pageState = PageState.loaded;
      notifyListeners();

      if (error is HttpException) {
        _view.onError(error.getMessage);
        return;
      }
      _view.onError(error.toString());
    });
  }

  clearData() {
    airtimeModel = AirtimeModel();
  }
}

abstract class AirtimeView {
  void onSuccess(String message);
  void onError(String message);
  void onPInVerify();
  void onPreView();
}
