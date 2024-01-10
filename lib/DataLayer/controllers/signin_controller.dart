import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../../Constant/validation.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../UILayer/utils/device_info.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../LocalData/local_data_storage.dart';
import '../model/generic_model_response.dart';
import '../model/login_response_model.dart';
import '../model/user_credential_model.dart';
import '../repository/auth_repository.dart';
import 'biomertic_controller.dart';

class SignInController extends ChangeNotifier {
  UserCredentialModel userCredentialModel = UserCredentialModel();
  PageState pageState = PageState.loaded;
  LOGINView? _view;
  ForgetPasswordView? _forgetPasswordView;

  late bool loginWithPhoneNumber = true;

  set forgetView(ForgetPasswordView forgetPasswordView) {
    _forgetPasswordView = forgetPasswordView;
  }

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
    userCredentialModel.email = v.replaceAll(' ', '');
  }

  setLoginType(bool v) async {
    loginWithPhoneNumber = v;
    await initCredential();
    notifyListeners();
  }

  saveData(LoginResponseModel result) {
    LocalDataStorage.saveUserData(result.data!);
    LocalDataStorage.saveUserPermission(result.permission);
    LocalDataStorage.saveUserAppSettings(result.appSettings);
    LocalDataStorage.saveTerminalConfig(result.terminalConfig);
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

    String? token = await FirebaseMessaging.instance.getToken();
    userCredentialModel.token = token;
    data["device_id"] = token;

    String? deviceID = await DeviceInfo.getDeviceID();
    String? deviceName = await DeviceInfo.getDeviceName();
    userCredentialModel.deviceIdentifier = deviceID;
    userCredentialModel.deviceName = deviceName;
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
        print(result);
        //save user
        saveData(result);
        _view?.onSuccess(result.message ?? "");
      } else {
        if (result.isNewDevice == true) {
          //save user
          saveData(result);
          _view?.onNewDevice(result.message ?? "");
        } else {
          _view?.onError(result.message ?? "");
        }
      }

      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      print(e);
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
      loginWithPhoneNumber = true;
    } else if (isNotEmpty(_credentialModel.email)) {
      data["email"] = _credentialModel.email;
      loginWithPhoneNumber = false;
    }
    // loginWithPhoneNumber  determine the route to push the auth data ;

    if (isNotEmpty(_credentialModel.password)) {
      data["password"] = _credentialModel.password;
    }

    BiometricController.authenticate().then((value) {
      if (value == true && data.isNotEmpty) {
        loginLogic(_credentialModel);
      }
    });
  }

  Future initCredential() async {
    UserCredentialModel? _credentialModel =
        await LocalDataStorage.getUserCredential();
    if (_credentialModel != null) {
      _credentialModel.password = "";
      _view?.onSetUserCredential(_credentialModel);
      userCredentialModel = _credentialModel;
    }
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

  Future<bool?> deleteAccount() async {
    try {
      GenericResponse genericResponse = await AuthRepository().deleteAccount();
      return genericResponse.status;
    } catch (e) {
      return false;
    }
  }

  forgetPassword() {
    if (ValidationController().validateEmail(userCredentialModel.email ?? "")) {
      _forgetPasswordView?.onError("Please enter a valid email");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    AuthRepository()
        .forgetPassword({"email": userCredentialModel.email}).then((value) {
      if (value.status == true) {
        _forgetPasswordView?.onSuccess(value.message ?? "");
      } else {
        _forgetPasswordView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _forgetPasswordView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }
}

abstract class LOGINView {
  void onSuccess(String message);
  void onError(String message);
  void onNewDevice(String message);
  void onSetUserCredential(UserCredentialModel userCredentialModel);
  void onValidate();
}

abstract class ForgetPasswordView {
  void onSuccess(String message);
  void onError(String message);
}
