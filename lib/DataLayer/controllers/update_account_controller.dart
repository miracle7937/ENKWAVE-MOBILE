import 'package:enk_pay_project/DataLayer/repository/setting_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../model/bank_list_response.dart';
import '../repository/transfer_repository.dart';

class UpdateAccountController extends ChangeNotifier {
  PageState pageState = PageState.loaded;
  List<Bank> listOfBank = [];
  UpdateAccountView? _updateAccountView;
  Bank? selectedBank;
  String? accountNumber, accountName;

  set setBank(v) {
    selectedBank = v;
  }

  setUpdateAccountView(v) {
    _updateAccountView = v;
  }

  getListOFBank() {
    if (listOfBank.isEmpty) {
      pageState = PageState.loading;
      TransferRepository().fetchTransferProperties().then((value) {
        if (value.data != null) {
          listOfBank = value.data!;
        } else {
          _updateAccountView?.onError("Fetching banks fails");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((v) {
        pageState = PageState.loaded;
        notifyListeners();
        _updateAccountView?.onError(v.toString());
      });
    }
  }

  bankAccountVerification() {
    if (isNotEmpty(selectedBank?.bankCbnCode) && isNotEmpty(accountNumber)) {
      pageState = PageState.loading;
      notifyListeners();
      var map = <String, dynamic>{};
      map["account_number"] = accountNumber;
      map["bank_code"] = selectedBank?.bankCbnCode;
      TransferRepository.verifyBankAccount(map).then((value) {
        if (value.status == true) {
          accountName = value.accountName;
        } else {
          _updateAccountView?.onError(value.message ?? "");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((onError) {
        pageState = PageState.loaded;
        notifyListeners();
        _updateAccountView?.onError(onError.toString());
      });
    } else {
      _updateAccountView?.onError("Ensure no empty field(s) ");
    }
  }

  onPinVerification() {
    if (isNotEmpty(selectedBank?.bankCbnCode) && isNotEmpty(accountName)) {
      _updateAccountView?.onPinVerification();
    } else {
      _updateAccountView?.onError("Please, verify the account number ");
    }
  }

  updateAccount() {
    pageState = PageState.loading;
    notifyListeners();
    var map = <String, dynamic>{};
    map["account_number"] = accountNumber;
    map["account_name"] = accountName;
    map["bank_code"] = selectedBank?.bankCbnCode;
    map["bank_name"] = selectedBank?.bankName;

    SettingRepository().updateAccountInfo(map).then((value) {
      if (value.status == true) {
        _updateAccountView?.onSuccess(value.message ?? "");
      } else {
        _updateAccountView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      pageState = PageState.loaded;
      notifyListeners();
      _updateAccountView?.onError(onError.toString());
    });
  }

  clear() {
    selectedBank = null;
    accountNumber = null;
    accountName == null;
  }
}

abstract class UpdateAccountView {
  onSuccess(String message);
  onError(String message);
  onPinVerification();
}
