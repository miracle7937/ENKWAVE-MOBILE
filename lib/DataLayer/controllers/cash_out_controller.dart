import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../model/cash_out_request.dart';
import '../repository/dashboard_repository.dart';

class CashOutController extends ChangeNotifier {
  CashOutRequest cashOutRequest = CashOutRequest();
  UserWallet? userWallet;
  List<UserWallet>? listOfUserWallets;
  PageState pageState = PageState.loaded;
  bool isInitialLoading = false;
  CashOutView? _cashOutView;
  String? _transferCharge;

  int getTransferCharge() => int.parse(_transferCharge ?? "0");
  String? getTotal() {
    if (isNotEmpty(cashOutRequest.amount)) {
      int total = int.parse(cashOutRequest.amount!) + getTransferCharge();
      return total.toString();
    }
    return null;
  }

  set setPin(String pin) {
    cashOutRequest.pin = pin;
  }

  setView(v) {
    _cashOutView = v;
  }

  set setAmount(String v) {
    cashOutRequest.amount = v;
  }

  set setUserWallet(UserWallet v) {
    userWallet = v;
    cashOutRequest.wallet = v.key;
    notifyListeners();
  }

  onProcessTransfer() {
    if (cashOutRequest.isValid()) {
      _cashOutView?.onPinVerify();
    } else {
      _cashOutView?.onError("Please, ensure your field are filled correctly");
    }
  }

  fetchUserWallet() {
    if (listOfUserWallets == null) {
      isInitialLoading = true;
      DashboardRepository().getWalletCharge().then((value) {
        listOfUserWallets = value.account;
        _transferCharge = value.transferCharge;
        isInitialLoading = false;
        notifyListeners();
      }).catchError((onError) {
        isInitialLoading = false;
        notifyListeners();
        _cashOutView?.onError(onError.toString());
      });
    }
  }

  userCashOut() {
    pageState = PageState.loading;
    notifyListeners();
    DashboardRepository().cashOut(cashOutRequest.toJson()).then((value) {
      if (value.status == true) {
        _cashOutView?.onSuccess(value.message!);
      } else {
        _cashOutView?.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((error) {
      pageState = PageState.loaded;
      notifyListeners();
      _cashOutView?.onError(error.toString());
    });
  }

  clearAll() {
    listOfUserWallets = null;
    userWallet = null;
  }
}

abstract class CashOutView {
  onSuccess(String message);
  onError(String message);
  onPinVerify();
  onCashOut();
}
