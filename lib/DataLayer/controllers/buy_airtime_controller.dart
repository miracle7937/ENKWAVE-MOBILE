import 'dart:developer';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/repository/airtime_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/validation.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../model/airtime_model.dart';
import '../model/buy_airtime_model.dart';

class AirtimeController with ChangeNotifier {
  AirtimeView? _view;
  PageState? pageState;
  late NetworkSelector airTimeRouteSelector;
  AirtimeModel airtimeModel = AirtimeModel();
  BuyAirtimeModel buyAirtimeModel = BuyAirtimeModel();
  List<UserWallet>? userWallet;
  UserWallet? selectedUserWallet;

  set setPin(String v) {
    buyAirtimeModel.pin = v;
  }

  setView(AirtimeView view) async {
    _view = view;
  }

  set selectWallet(UserWallet v) {
    selectedUserWallet = v;
    buyAirtimeModel.wallet = v.key;
    notifyListeners();
  }

  set setPhone(String v) {
    buyAirtimeModel.phone = PhoneNumber.format(v);
  }

  set setAirtimeType(NetworkSelector value) {
    airTimeRouteSelector = value;
    buyAirtimeModel.serviceId = getServiceId(value).toUpperCase();
  }

  set setAmount(String v) {
    buyAirtimeModel.amount = v;
  }

  getWallet() {
    if (pageState != null) {
      return;
    }
    pageState = PageState.loading;
    AirTimeRepository().getWallet().then((value) {
      userWallet = value;
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stack) {
      print(stack);
      pageState = PageState.loaded;
      notifyListeners();
      _view!.onError(error.toString());
    });
  }

  onSummit() {
    validateDataForm();
  }

  buyAirtel() {
    pageState = PageState.loading;
    notifyListeners();
    AirTimeRepository().byAirTime(buyAirtimeModel.toJson()).then((value) {
      pageState = PageState.loaded;
      notifyListeners();
      if (value.status != true) {
        _view!.onError(value.message!);
      } else {
        _view!.onSuccess(value.message!);
      }
    }).catchError((error, _) {
      log(error.toString());
      log(_.toString());
      pageState = PageState.loaded;
      notifyListeners();
      _view!.onError(error.toString());
    });
  }

  validateDataForm() {
    print(buyAirtimeModel.toJson());
    if (isEmpty(buyAirtimeModel.serviceId)) {
      _view!.onError("Please select a provider");
      return;
    }
    if (!ValidationController().isValidPhoneNumber(buyAirtimeModel.phone)) {
      _view!.onError("Please provide a valid number");
      return;
    }

    _view!.onPInVerify();
  }

  clearData() {
    buyAirtimeModel = BuyAirtimeModel();
    pageState = null;
    selectedUserWallet = null;
  }
}

abstract class AirtimeView {
  void onSuccess(String message);
  void onError(String message);
  void onPInVerify();
  void onBuyAirtime();
}
