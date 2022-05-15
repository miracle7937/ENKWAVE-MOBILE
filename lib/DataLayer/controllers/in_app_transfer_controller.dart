import 'package:enk_pay_project/DataLayer/abstract_class/internal_transfer_view.dart';
import 'package:enk_pay_project/DataLayer/model/in_app_transfer_model.dart';
import 'package:enk_pay_project/DataLayer/repository/transfer_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/form_valitation.dart';
import 'package:flutter/cupertino.dart';

class InAppTransferController with ChangeNotifier {
  late InternalTransferView _view;
  PageState pageState = PageState.loaded;
  String? get searchName => _searchName;
  String? _searchName;
  set setView(InternalTransferView view) {
    _view = view;
  }

  InAppModelData inAppModelData = InAppModelData();

  set phoneNumber(String s) {
    inAppModelData.phoneNumber = s;
  }

  set setAmount(String amount) {
    inAppModelData.amount = amount;
  }

  set setDesc(String des) {
    inAppModelData.description = des;
  }

  transfer() {
    pageState = PageState.loading;
    notifyListeners();
    TransferRepository().inAppTransfer(inAppModelData).then((value) {
      if (value.success == true) {
        _view.onSuccess(value.message!);
      } else {
        _view.onError(value.message!);
      }
      pageState = PageState.loading;
      notifyListeners();
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

  verifyUserNumber(String number) {
    if (validateMobile(number)) {
      Map data = {"phoneNumber": number};
      TransferRepository().inAppVerifyUser(data).then((value) {
        if (value.data!.isNotEmpty) {
          _searchName =
              "${value.data![0].firstName} " " ${value.data![0].middleName}";
          notifyListeners();
        }
      });
    }
  }

  clearAPP() {
    _searchName = null;
    inAppModelData.phoneNumber = null;
  }
}
