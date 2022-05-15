import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/Constant/validation.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/registration_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:enk_pay_project/DataLayer/repository/auth_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import 'biomertic_controller.dart';

class AuthController extends ChangeNotifier {
  RegistrationModel registrationModel = RegistrationModel();
  UserCredentialModel userCredentialModel = UserCredentialModel();

  late AuthView _view;
  late OTPView _otpView;
  late bool loginWithEmail = false;
  String otp = "";
  bool checkedTermsCondition = false;
  PageState pageState = PageState.loaded;
  late String _identifier;
  late RegistrationResponse _registrationResponse;

  set view(AuthView v) {
    _view = v;
  }

  setIdentifier(String identifier) {
    _identifier = identifier;
  }

  set otpView(OTPView v) {
    _otpView = v;
  }

  set setLoginType(bool v) {
    loginWithEmail = v;
    notifyListeners();
  }

  setFirstName(String v) {
    registrationModel.firstName = v;
  }

  setOTp(String v) {
    otp = v;
  }

  setLastName(String v) {
    registrationModel.lastName = v;
  }

  setMiddleName(String v) {
    registrationModel.middleName = v;
  }

  setPassword(String v) {
    registrationModel.password = v;
    userCredentialModel.password = v;
  }

  setPasswordConfirmation(String v) {
    registrationModel.passwordConfirmation = v;
  }

  setPhoneConfirmation(String v) {
    registrationModel.phone = v;
    userCredentialModel.phone = v;
  }

  setEmail(String v) {
    registrationModel.email = v;
    userCredentialModel.email = v;
  }

  setTermsCondition(bool v) {
    checkedTermsCondition = v;
    notifyListeners();
  }

  register() async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result = await AuthRepository().signUP(registrationModel);
      if (result.success == true) {
        _registrationResponse = result;
        _view.onSuccess(result);
      }
      _view.onError(result.message!);
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      if (e is HttpException) {
        _view.onError((e).getMessage);
        return;
      }
      _view.onError((e).toString());
    }
  }

  logIn() async {
    Map data = {};
    if (isNotEmpty(registrationModel.phone)) {
      data["phone"] = registrationModel.phone;
    }
    if (isNotEmpty(registrationModel.password)) {
      data["password"] = registrationModel.password;
    }
    if (isNotEmpty(registrationModel.email)) {
      data["email"] = registrationModel.email;
    }
    LocalDataStorage.saveUserCredential(userCredentialModel);
    loginLogic(data);
  }

  biometricLogin() async {
    UserCredentialModel? _credentialModel =
        await LocalDataStorage.getUserCredential();
    debugPrint(_credentialModel!.toJson().toString());
    Map data = {};
    if (isNotEmpty(_credentialModel.phone)) {
      data["phone"] = _credentialModel.phone;
    }
    if (isNotEmpty(_credentialModel.password)) {
      data["password"] = _credentialModel.password;
    }
    if (isNotEmpty(_credentialModel.email)) {
      data["email"] = _credentialModel.email;
    }
    BiometricController.authenticate().then((value) {
      if (value == true && data.isNotEmpty) {
        loginLogic(data);
      }
    });
  }

  loginLogic(Map data) async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result = await AuthRepository().login(data);
      if (result.success == true) {
        LocalDataStorage.saveUserData(result.data!);
        _view.onSuccess(null);
        return;
      }
      _view.onError(result.message!);
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      if (e is HttpException) {
        _view.onError((e).getMessage);
        return;
      }
      _view.onError((e).toString());
    }
  }

  otpVerification() async {
    var data = {"identifier": _registrationResponse.data!.id, "token": otp};
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result = await AuthRepository.verifyOTP(data);

      if (result.success == true) {
        _otpView.onVerify(result.message.toString());
        return;
      }
      _otpView.onError(result.message!);
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      if (e is HttpException) {
        _otpView.onError((e).getMessage);
        return;
      }
      _otpView.onError((e).toString());
    }
  }

  sendOTP() async {
    pageState = PageState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 5));
    pageState = PageState.loaded;
    notifyListeners();
    _otpView.onSuccess("OTP send successfully");
    // AuthRepository.sendOTP({'identifier': _registrationResponse.data!.id})
    //     .then((value) {
    //   if (value.success == true) {
    //     _otpView.onSuccess(value.message.toString());
    //     return;
    //   } else {
    //     _otpView.onError(value.message.toString());
    //   }
    //   pageState = PageState.loaded;
    //   notifyListeners();
    // }).onError((error, i) {
    //   _otpView.onError(error.toString());
    //   pageState = PageState.loaded;
    //   notifyListeners();
    // });
  }

  void validateRegistrationForm() {
    if (ValidationController().validateEmail(registrationModel.email ?? "")) {
      _view.onError("Your email address is not valid");
      return;
    } else if (registrationModel.phone == null) {
      _view.onError("Your phone number is not valid");
      return;
    } else if (registrationModel.firstName == null) {
      _view.onError("Please Enter your First Name");
      return;
    } else if (registrationModel.middleName == null) {
      _view.onError("Please Enter your Middle Name");
      return;
    } else if (!checkedTermsCondition) {
      _view.onError("Please approve terms and conditions");
      return;
    } else if (registrationModel.password == null) {
      _view.onError("Password field should not be empty");
      return;
    } else if (registrationModel.password !=
        registrationModel.passwordConfirmation) {
      _view.onError("Password doesn't match");
      return;
    } else if (registrationModel.password != null &&
        (registrationModel.password!.length) < 4) {
      _view.onError("Password too short");
      return;
    }
    _view.onValidate();
  }

  validateSIGNInForm() {
    if (loginWithEmail) {
      if (ValidationController().validateEmail(registrationModel.email ?? "")) {
        _view.onError("Your email address is not valid");
        return;
      }
    } else {
      if (registrationModel.phone == null) {
        _view.onError("Your phone number is not valid");
        return;
      }
    }

    if (registrationModel.password != null &&
        (registrationModel.password!.length) < 4) {
      _view.onError("Password too short");
      return;
    }
    _view.onValidate();
  }
}

abstract class AuthView {
  void onSuccess(RegistrationResponse? response);
  void onError(String message);
  void onValidate();
}

abstract class OTPView {
  void onSuccess(String message);
  void onError(String message);
  void onVerify(String message);
}
