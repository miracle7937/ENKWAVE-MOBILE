import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:flutter/cupertino.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../abstract_class/internal_transfer_view.dart';
import '../model/api_property_model.dart';
import '../repository/api_service_repository.dart';

class ApiServiceController with ChangeNotifier {
  PageState? pageState;
  ApiServiceProperty? apiServiceProperty;
  late APIServiceView _view;
  String name = '';
  String email = '';
  String amount = '';
  Service? selectedService;
  UserWallet? userWallet;

  setView(v) {
    _view = v;
  }

  setService(v) {
    selectedService = v;
    notifyListeners();
  }

  setUserWallet(v) {
    userWallet = v;
    notifyListeners();
  }

  setEmail(v) {
    email = v;
  }

  setAmount(v) {
    amount = v;
  }

  getWallet() {
    if (pageState != null) {
      return;
    }
    pageState = PageState.loading;
    ApiServiceRepository().fetchTransferProperties().then((value) {
      if (value.account != null) {
        apiServiceProperty = value;
      } else {
        _view.onError("Fail to get User Wallet");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stack) {
      pageState = PageState.error;
      notifyListeners();

      _view.onError(error.toString());
    });
  }

  serviceLookUP() {
    pageState = PageState.loading;
    Map data = {};
    data["id"] = selectedService?.id;
    data["email"] = email;
    if (isEmpty(email) || selectedService?.id == null) {
      _view.onError("Invalid input");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    ApiServiceRepository().serviceCheck(data).then((value) {
      if (value.status == true) {
        name = value.user ?? "";
      } else {
        _view.onError(value.message ?? "Fail to verify account");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stack) {
      pageState = PageState.error;
      notifyListeners();
      _view.onError(error.toString());
    });
  }

  fundService() {
    pageState = PageState.loading;
    Map data = {};
    data["id"] = selectedService?.id;
    data["email"] = email;
    data["amount"] = amount;
    if (isNotEmpty(email) && selectedService?.id != null && isEmpty(amount)) {
      _view.onError("Invalid input data");
      return;
    }
    ApiServiceRepository().serviceFund(data).then((value) {
      if (value.status == true) {
        _view.onSuccess(value.message!);
      } else {
        _view.onError(value.message ?? "Fail to fund service account");
      }

      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stack) {
      pageState = PageState.error;
      notifyListeners();
      _view.onError(error.toString());
    });
  }

  void disposeAll() {
    name = '';
    email = '';
    amount = '';
    selectedService = null;
    userWallet = null;
  }
}
