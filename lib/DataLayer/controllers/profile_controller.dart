import 'package:flutter/cupertino.dart';

import '../../Constant/validation.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../repository/set_pin_repository.dart';

class ProfileController extends ChangeNotifier {
  String? _email;
  PageState pageState = PageState.loaded;
  ForgetPinView? _forgetPinView;

  setForgetPinView(v) {
    _forgetPinView = v;
  }

  setEmail(String v) {
    _email = v;
  }

  forgetPin() {
    if (ValidationController().validateEmail(_email ?? "")) {
      _forgetPinView?.onError("Please enter a valid email");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    SettingPinRepository().forgetPin({"email": _email}).then((value) {
      if (value.status == true) {
        _forgetPinView?.onSuccess(value.message ?? "");
      } else {
        _forgetPinView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _forgetPinView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }
}

abstract class ForgetPinView {
  onSuccess(String massage);
  onError(String massage);
}
