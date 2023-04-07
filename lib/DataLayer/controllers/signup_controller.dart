import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../../Constant/validation.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../LocalData/local_data_storage.dart';
import '../model/user_credential_model.dart';
import '../repository/auth_repository.dart';
import 'biomertic_controller.dart';

class SignUpController extends ChangeNotifier {
  UserCredentialModel userCredentialModel = UserCredentialModel();
  PageState pageState = PageState.loaded;
  LOGINView? _view;
  late bool loginWithPhoneNumber = true;

  set view(LOGINView v) {
    _view = v;
  }

  setPassword(String v) {
    userCredentialModel.password = v;
  }

  setPhone(String v) {
    userCredentialModel.phone = PhoneNumber.format(v);
  }

  setEmail(String v) {
    userCredentialModel.email = v;
  }

  set setLoginType(bool v) {
    loginWithPhoneNumber = v;
    notifyListeners();
  }

  logIn() async {
    Map data = {};
    if (isNotEmpty(userCredentialModel.phone)) {
      data["phone"] = userCredentialModel.phone;
    }
    if (isNotEmpty(userCredentialModel.password)) {
      data["password"] = userCredentialModel.password;
    }
    if (isNotEmpty(userCredentialModel.email)) {
      data["email"] = userCredentialModel.email;
    }
    LocalDataStorage.saveUserCredential(userCredentialModel);
    loginLogic(userCredentialModel);
  }

  loginLogic(UserCredentialModel? credentialModel) async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result = await AuthRepository()
          .login(credentialModel!.toJson(), phoneLogin: loginWithPhoneNumber);
      if (result.status == true) {
        LocalDataStorage.saveUserData(result.data!);
        LocalDataStorage.saveUserPermission(result.permission!);
        LocalDataStorage.saveUserAppSettings(result.appSettings!);
        _view?.onSuccess(result.message ?? "");
      } else {
        _view?.onError(result.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      _view?.onError(e.toString() ?? "");
    }
  }

  biometricLogin() async {
    UserCredentialModel? _credentialModel =
        await LocalDataStorage.getUserCredential();
    debugPrint(_credentialModel!.toJson().toString());
    Map data = {};
    if (isNotEmpty(_credentialModel.phone)) {
      data["phone"] = _credentialModel.phone;
    } else if (isNotEmpty(_credentialModel.email)) {
      data["email"] = _credentialModel.email;
    }

    if (isNotEmpty(_credentialModel.password)) {
      data["password"] = _credentialModel.password;
    }

    BiometricController.authenticate().then((value) {
      if (value == true && data.isNotEmpty) {
        loginLogic(_credentialModel);
      }
    });
  }

  validateSIGNInForm() {
    if (loginWithPhoneNumber) {
      if (isEmpty(userCredentialModel.phone)) {
        _view?.onError("Your phone number is not valid");
        return;
      }
    } else {
      if (ValidationController()
          .validateEmail(userCredentialModel.email ?? "")) {
        _view?.onError("Your email address is not valid");
        return;
      }
    }

    if (userCredentialModel.password != null &&
        (userCredentialModel.password!.length) < 4) {
      _view?.onError("Password too short");
      return;
    }
    _view?.onValidate();
  }

  Future logOut() async {
    try {
      var result = await AuthRepository.logOut();
      if (result.status == true) {
        LocalDataStorage.clearUser();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
    }
  }
}

abstract class LOGINView {
  void onSuccess(String message);
  void onError(String message);
  void onValidate();
}
