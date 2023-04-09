import 'package:flutter/cupertino.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../repository/auth_repository.dart';

class PinVerificationController extends ChangeNotifier {
  PageState pageState = PageState.loaded;
  PinView? _pinView;
  String? pin;

  set setView(v) {
    _pinView = v;
  }

  verifyPin(String pin) {
    this.pin = pin;
    pageState = PageState.loading;
    notifyListeners();
    AuthRepository.verifyPin({"pin": pin}).then((value) {
      if (value.status == true) {
        _pinView?.onSuccess(value.message ?? "");
      } else {
        _pinView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((error, stackTrace) {
      _pinView?.onError(error.toString());
      pageState = PageState.loaded;
      notifyListeners();
    });
  }
}

abstract class PinView {
  onSuccess(String message);
  onError(String message);
}
