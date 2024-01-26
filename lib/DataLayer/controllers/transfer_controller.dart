import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../Constant/string_values.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';

class TransferController with ChangeNotifier {
  List<Bank> listOfBank = [];
  List<UserWallet> userWallet = [];
  BankTransferModel bankTransferModel = BankTransferModel();
  Bank? selectedBank;
  String? accountNumber, accountName;
  String? _transferCharge;
  Position? position;

  int getTransferCharge() => int.parse(_transferCharge ?? "0");

  UserWallet? selectedUserWallet;
  PageState? pageState;
  late OnBankTransfer _onBankTransfer;

  disposeAll() {
    bankTransferModel = BankTransferModel();
    selectedUserWallet = null;
    selectedBank = null;
    accountName = null;
    pageState = null;
    listOfBank.clear();
    userWallet.clear();

    print("Clear trasnfer");
  }

  set onSetTransferView(OnBankTransfer v) {
    _onBankTransfer = v;
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    bankTransferModel.longitude = position?.longitude.toString();
    bankTransferModel.latitude = position?.latitude.toString();
  }

  set setPin(String v) {
    bankTransferModel.pin = v;
  }

  set setBank(Bank bank) {
    selectedBank = bank;
    bankTransferModel.bankCode = bank.bankCbnCode;
    bankTransferModel.receiverBank = bank.bankName;
  }

  set selectWallet(UserWallet value) {
    bankTransferModel.wallet = value.key;
    selectedUserWallet = value;
    notifyListeners();
  }

  set selectAccount(String account) {
    bankTransferModel.accountNumber = account;
  }

  set selectAmount(String amount) {
    bankTransferModel.amount = amount;
    notifyListeners();
  }

  set setNarration(String v) {
    bankTransferModel.narration = v;
  }

  String? getTotal() {
    if (isNotEmpty(bankTransferModel.amount)) {
      int total = int.parse(bankTransferModel.amount!) + getTransferCharge();
      return total.toString();
    }
    return null;
  }

  bankAccountVerification() {
    if (isNotEmpty(bankTransferModel.bankCode) &&
        isNotEmpty(bankTransferModel.accountNumber)) {
      //clear the initial bankname
      accountName = null;
      pageState = PageState.loading;
      notifyListeners();
      var map = <String, dynamic>{};
      map["account_number"] = bankTransferModel.accountNumber;
      map["bank_code"] = bankTransferModel.bankCode;
      TransferRepository.verifyBankAccount(map).then((value) {
        if (value.status == true) {
          // _onBankTransfer.onSuccess(value.message ?? "");
          accountName = value.accountName;
          bankTransferModel.customerName = value.accountName;
        } else {
          _onBankTransfer.onError(value.message ?? "");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((onError) {
        pageState = PageState.loaded;
        notifyListeners();
        _onBankTransfer.onError(onError.toString());
      });
    } else {
      _onBankTransfer.onError("Ensure no empty field(s) ");
    }
  }

  getListOFBank() {
    if (pageState == null) {
      pageState = PageState.loading;
      TransferRepository().fetchTransferProperties().then((value) {
        if (value.data != null) {
          listOfBank = value.data!;
          userWallet = value.userWallets!;
          _transferCharge = value.transferCharge;
        } else {
          _onBankTransfer.onError("Fetching banks fails");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((v) {
        pageState = PageState.loaded;
        notifyListeners();
        _onBankTransfer.onError(v.toString());
      });
    }
  }

  bankTransfer() {
    if (isNotEmpty(bankTransferModel.bankCode) &&
        isNotEmpty(bankTransferModel.accountNumber) &&
        isNotEmpty(bankTransferModel.amount) &&
        isNotEmpty(bankTransferModel.wallet)) {
      print(bankTransferModel.toJson());
      pageState = PageState.loading;
      notifyListeners();
      TransferRepository().bankTransfer(bankTransferModel).then((value) {
        if (value.status == true) {
          _onBankTransfer.onTransferSuccess(value.message ?? "");
        } else {
          _onBankTransfer.onError(value.message ?? "");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((onError) {
        pageState = PageState.loaded;
        notifyListeners();
        _onBankTransfer.onError(onError.toString());
      });
    } else {
      _onBankTransfer.onError("Ensure no empty field(s) ");
    }
  }

  validateTransferForm() {
    print(bankTransferModel.toJson());
    if (isEmpty(bankTransferModel.bankCode)) {
      _onBankTransfer.onError("Please select bank");
      return;
    }
    if (isEmpty(bankTransferModel.accountNumber)) {
      _onBankTransfer.onError("Please input  Beneficiary account number");
      return;
    }

    if (isEmpty(bankTransferModel.amount)) {
      _onBankTransfer.onError("Please input  transaction amount");
      return;
    }
    _onBankTransfer.onTransferPinVerification();
  }
}

abstract class OnBankTransfer {
  onSuccess(String message);
  onPreview(String message);
  onError(String message);
  onTransferSuccess(String message);
  onTransferPinVerification();
  onTransfer();
}

abstract class OnInAppTransfer {
  onSuccess(String message);
  onError(String message);
}
