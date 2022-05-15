import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:flutter/cupertino.dart';

class TransferController with ChangeNotifier {
  List<Bank> listOfBank = [];
  BankTransferModel bankTransferModel = BankTransferModel();
  Bank? selectedBank;
  String? accountNumber, transAmount;

  late OnBankTransfer _onBankTransfer;
  set onSetTransferView(OnBankTransfer v) {
    _onBankTransfer = v;
  }

  set selectBank(Bank bank) {
    bankTransferModel.destinationBankCode = bank.bankCbnCode;
  }

  set selectAccount(String account) {
    bankTransferModel.destinationAccount = account;
  }

  set selectAmount(String amount) {
    bankTransferModel.amount = amount;
  }

  getListOFBank() {
    debugPrint("Get All Banks");
    if (listOfBank.isEmpty) {
      TransferRepository().fetchListOfBanks().then((value) {
        if (value.data != null) {
          listOfBank.addAll(value.data!);
        } else {
          _onBankTransfer.onError("Fetching banks fails");
        }
      }).catchError((v) {
        _onBankTransfer.onError(v.toString());
      });
    }
  }

  bankTransfer() {
    TransferRepository().bankTransfer(bankTransferModel).then((value) {
      if (value.data == null) {}
    });
  }
}

abstract class OnBankTransfer {
  onSuccess(String message);
  onError(String message);
}

abstract class OnInAppTransfer {
  onSuccess(String message);
  onError(String message);
}
