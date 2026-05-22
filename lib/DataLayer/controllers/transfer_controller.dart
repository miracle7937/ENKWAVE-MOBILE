import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../Constant/string_values.dart';
import '../utils/amount_utils.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';

class TransferController with ChangeNotifier {
  List<Bank> listOfBank = [];
  List<UserWallet> userWallet = [];
  List<Beneficariy> getBeneficary = [];
  BankTransferModel bankTransferModel = BankTransferModel();
  Bank? selectedBank;
  String? accountNumber, accountName;
  String? lastTransferRefId;
  String? _transferCharge;
  Position? position;
  bool? beneficiary;

  int getTransferCharge() => int.parse(_transferCharge ?? "0");

  UserWallet? selectedUserWallet;
  PageState? pageState;
  bool isVerifyingAccount = false;
  String? verifyError;
  late OnBankTransfer _onBankTransfer;

  disposeAll() {
    bankTransferModel = BankTransferModel();
    selectedUserWallet = null;
    selectedBank = null;
    accountName = null;
    lastTransferRefId = null;
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

  set setBeneficiary(bool v) {
    bankTransferModel.beneficiary = v;
    notifyListeners();
  }

  set setBank(Bank bank) {
    selectedBank = bank;
    bankTransferModel.bankCode = bank.bankCbnCode;
    bankTransferModel.receiverBank = bank.bankName;
    notifyListeners();
  }

  set selectWallet(UserWallet value) {
    bankTransferModel.wallet = value.key;
    selectedUserWallet = value;
    notifyListeners();
  }

  set selectAccount(String account) {
    bankTransferModel.accountNumber = account;
    notifyListeners();
  }

  void clearVerifyFeedback() {
    verifyError = null;
    accountName = null;
    bankTransferModel.customerName = null;
    notifyListeners();
  }

  set selectAmount(String amount) {
    bankTransferModel.amount = parseAmountDigits(amount);
    notifyListeners();
  }

  set setNarration(String v) {
    bankTransferModel.narration = v;
  }

  String? getTotal() {
    final raw = bankTransferModel.amount;
    if (isNotEmpty(raw)) {
      final amount = int.tryParse(raw!);
      if (amount == null || amount <= 0) return null;
      return (amount + getTransferCharge()).toString();
    }
    return null;
  }

  bankAccountVerification({bool showDialogOnError = false}) {
    if (isNotEmpty(bankTransferModel.bankCode) &&
        isNotEmpty(bankTransferModel.accountNumber)) {
      accountName = null;
      verifyError = null;
      isVerifyingAccount = true;
      notifyListeners();
      var map = <String, dynamic>{};
      map["account_number"] = bankTransferModel.accountNumber;
      map["bank_code"] = bankTransferModel.bankCode;
      TransferRepository.verifyBankAccount(map).then((value) {
        if (value.status == true) {
          accountName = value.accountName;
          bankTransferModel.customerName = value.accountName;
          verifyError = null;
        } else {
          verifyError = value.message ?? 'Could not verify account';
          if (showDialogOnError) {
            _onBankTransfer.onError(verifyError!);
          }
        }
        isVerifyingAccount = false;
        notifyListeners();
      }).catchError((onError) {
        isVerifyingAccount = false;
        verifyError = onError.toString().replaceFirst('Exception: ', '');
        notifyListeners();
        if (showDialogOnError) {
          _onBankTransfer.onError(verifyError!);
        }
      });
    } else {
      verifyError = 'Select a bank and enter account number';
      notifyListeners();
      if (showDialogOnError) {
        _onBankTransfer.onError(verifyError!);
      }
    }
  }

  getListOFBank() {
    if (pageState == null) {
      pageState = PageState.loading;
      TransferRepository().fetchTransferProperties().then((value) {
        if (value.data != null) {
          listOfBank = value.data!;
          userWallet = value.userWallets ?? [];
          _transferCharge = value.transferCharge;
          getBeneficary = value.beneficiary ?? [];
          if (selectedUserWallet == null && userWallet.isNotEmpty) {
            selectWallet = userWallet.first;
          }
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
          lastTransferRefId = value.refTransId ?? value.eRef;
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
    if (isEmpty(bankTransferModel.wallet)) {
      _onBankTransfer.onError('Please select a wallet to pay from');
      return;
    }
    if (isEmpty(bankTransferModel.bankCode)) {
      _onBankTransfer.onError("Please select bank");
      return;
    }
    if (isEmpty(bankTransferModel.accountNumber)) {
      _onBankTransfer.onError("Please input  Beneficiary account number");
      return;
    }

    if (isEmpty(accountName) || isEmpty(bankTransferModel.customerName)) {
      _onBankTransfer.onError('Please verify the account number first');
      return;
    }

    if (isEmpty(bankTransferModel.amount)) {
      _onBankTransfer.onError("Please input  transaction amount");
      return;
    }
    _onBankTransfer.onTransferPinVerification();
  }
}

abstract mixin class OnBankTransfer {
  onSuccess(String message);
  onPreview(String message);
  onError(String message);
  onTransferSuccess(String message);
  onTransferPinVerification();
  onTransfer();
}

abstract mixin class OnInAppTransfer {
  onSuccess(String message);
  onError(String message);
}
