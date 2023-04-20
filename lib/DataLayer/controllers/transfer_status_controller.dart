import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/material.dart';

import '../model/transaction_status_model.dart';

class TransferStatusController with ChangeNotifier {
  PageState? pageState;
  TransactionStatusModel? transactionStatusModel;
  getTransaction(String ref) {
    if (pageState != null) {
      return;
    }
    pageState = PageState.loading;
    TransferRepository().getTransactionStatus({"ref_no": ref}).then((value) {
      if (value.status != null) {
        pageState = PageState.loaded;
        transactionStatusModel = value;
      } else {
        pageState = PageState.error;
      }
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.error;
      notifyListeners();
    });
  }

  clearAll() {
    pageState = null;
  }
}
