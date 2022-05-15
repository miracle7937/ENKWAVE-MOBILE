import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/create_pin_model.dart';
import 'package:enk_pay_project/DataLayer/repository/set_pin_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

class PinController with ChangeNotifier {
  String pin = "", verifyPin = "";
  late OnSetPin _onSetPin;
  late OnConfirmPinView _onConfirmPinView;
  late VerifyPinView _verifyPinView;
  late CreatePinModel createPinModel = CreatePinModel();
  var inputList = <int>[];
  PageState pageState = PageState.loaded;
  set setVerifyPin(VerifyPinView verifyPinView) {
    _verifyPinView = verifyPinView;
  }

  set setView(OnSetPin v) {
    _onSetPin = v;
  }

  set setConfirmView(OnConfirmPinView v) {
    _onConfirmPinView = v;
  }

  setPinVerify(String value) {
    verifyPin = value;
  }

  setPin(String value) async {
    pin = value;
    createPinModel.pin = value;
    createPinModel.phone = await LocalDataStorage.getPhone();
    _onSetPin.onEnterPin();
  }

  set setConfirmPin(String value) {
    createPinModel.pinConfirmation = value;
    if (value != pin) {
      _onConfirmPinView.onPinNotConfirmed("Incorrect pin");
    } else {
      pageState = PageState.loading;
      notifyListeners();
      SettingPinRepository().createPin(createPinModel).then((value) {
        if (value.status == true) {
          _onConfirmPinView.onSuccess(value.message!);
        } else {
          inputList.clear();
          _onConfirmPinView.onPinNotConfirmed(value.message!);
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((e) {
        pageState = PageState.loaded;
        notifyListeners();
        if (e is HttpException) {
          _onConfirmPinView.onPinNotConfirmed(e.getMessage);
          return;
        }
        _onConfirmPinView.onPinNotConfirmed(e.toString());
      });
    }
  }

  summitVerifyPin() {
    var map = {"pin": "081050"};
    pageState = PageState.loading;
    notifyListeners();
    SettingPinRepository().verifyPin(map).then((value) {
      pageState = PageState.loaded;
      notifyListeners();
      if (value.success == true) {
        _verifyPinView.onSuccess(value.message!);
      } else {
        inputList.clear();
        _verifyPinView.onError(value.message!);
      }
    }).catchError((e) {
      pageState = PageState.loaded;
      notifyListeners();
      if (e is HttpException) {
        _verifyPinView.onError(e.getMessage);
        return;
      }
      _verifyPinView.onError(e.toString());
    });
  }
}

abstract class OnSetPin {
  void onEnterPin();
  void onSuccess();
}

abstract class OnConfirmPinView {
  void onEnterConfirmPin();
  void onPinNotConfirmed(String message);
  void onSuccess(String message);
}

abstract class VerifyPinView {
  void onSuccess(String message);
  void onError(String message);
}
