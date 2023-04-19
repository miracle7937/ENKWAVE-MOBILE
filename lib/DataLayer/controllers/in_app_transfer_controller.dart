import 'package:enk_pay_project/Constant/validation.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/internal_transfer_view.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../model/bank_list_response.dart';

class InAppTransferController with ChangeNotifier {
  late InternalTransferView _view;
  PageState? pageState;
  String? get searchName => _searchName;
  String? _searchName;
  List<UserWallet>? userWallets;
  UserWallet? selectedUserWallet;
  set setView(InternalTransferView view) {
    _view = view;
  }

  InAppModelData inAppModelData = InAppModelData();

  set phoneNumber(String s) {
    inAppModelData.phone = PhoneNumber.format(s);
  }

  set setAmount(String amount) {
    inAppModelData.amount = amount;
  }

  set setDesc(String des) {
    inAppModelData.narration = des;
  }

  set setPin(String v) {
    inAppModelData.pin = v;
  }

  set selectWallet(UserWallet value) {
    inAppModelData.wallet = value.key;
    selectedUserWallet = value;
    notifyListeners();
  }

  getWallet() {
    if (pageState != null) {
      return;
    }
    pageState = PageState.loading;
    TransferRepository().getWallet().then((value) {
      if (value.status == true) {
        userWallets = value.userWallets;
      } else {
        _view.onError(value.message ?? "Fail to get User Wallet");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stack) {
      pageState = PageState.error;
      notifyListeners();

      _view.onError(error.toString());
    });
  }

  transfer() {
    pageState = PageState.loading;
    notifyListeners();
    TransferRepository().inAppTransfer(inAppModelData).then((value) {
      if (value.status == true) {
        _view.onSuccess(value.message!);
      } else {
        _view.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((error) {
      pageState = PageState.loaded;
      notifyListeners();
      _view.onError(error.toString());
    });
  }

  verifyUserNumber(String number) {
    if (ValidationController().isValidPhoneNumber(inAppModelData.phone)) {
      pageState = PageState.loading;
      notifyListeners();
      Map data = {"phone": PhoneNumber.format(number)};
      TransferRepository().inAppVerifyUser(data).then((value) {
        if (value.status == true) {
          _searchName = value.customerName;
        } else {
          _view.onFailNumberVerify(value.message ?? "");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((onError) {
        pageState = PageState.loaded;
        notifyListeners();
        _view.onFailNumberVerify(onError.toString());
      });
    }
  }

  validateTransferForm() {
    print(inAppModelData.toJson());
    if (isEmpty(inAppModelData.phone)) {
      _view.onError("Please provide beneficiary phone number");
      return;
    }
    if (isEmpty(_searchName)) {
      _view.onError("Ensure beneficiary is verify");
      return;
    }
    if (isEmpty(inAppModelData.amount)) {
      _view.onError("please provide amount");
      return;
    }
    _view.onPinVerification();
  }

  clearAPP() {
    _searchName = null;
    inAppModelData = InAppModelData();
    selectedUserWallet = null;
    pageState = null;
  }
}
