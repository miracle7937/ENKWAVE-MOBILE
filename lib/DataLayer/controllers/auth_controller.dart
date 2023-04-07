import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/Constant/validation.dart';
import 'package:enk_pay_project/DataLayer/model/registration_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';
import 'package:enk_pay_project/DataLayer/repository/auth_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/format_phone_number.dart';
import 'package:flutter/cupertino.dart';

import '../model/lga_response.dart';
import '../model/location_response.dart';

class AuthController extends ChangeNotifier with RegView {
  BasicPhoneEmailVerification basicPhoneEmailVerification =
      BasicPhoneEmailVerification.forRegistration;
  RegistrationModel registrationModel = RegistrationModel();
  late AuthView _view;
  late OTPView _otpView;
  late RequestOTPView _requestOTPView;
  String otp = "";
  bool checkedTermsCondition = false;
  PageState pageState = PageState.loaded;
  bool isSelectPhoneVerification = true;
  REGView? _regView;
  List<LocationData>? locationData;
  List<String>? allLgaData;
  LocationData? location;
  String? lgaData;

  setBasicPhoneEmailVerification(v) {
    basicPhoneEmailVerification = v;
  }

  setIsVerificationPhone(bool v) {
    isSelectPhoneVerification = v;
    notifyListeners();
  }

  set setGender(v) {
    registrationModel.gender = v;
    notifyListeners();
  }

  set requestOTPView(v) {
    _requestOTPView = v;
  }

  set view(AuthView v) {
    _view = v;
  }

  set otpView(OTPView v) {
    _otpView = v;
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

  setPassword(String v) {
    registrationModel.password = v;
  }

  setPasswordConfirmation(String v) {
    registrationModel.passwordConfirmation = v;
  }

  setPhone(String v) {
    registrationModel.phone = PhoneNumber.format(v);
    print(registrationModel.phone);
  }

  setEmail(String v) {
    registrationModel.email = v;
  }

  setTermsCondition(bool v) {
    checkedTermsCondition = v;
    notifyListeners();
  }

  set setNGState(LocationData v) {
    location = v;
    registrationModel.state = v.name;
    getAllLGA(v.name!);
    notifyListeners();
  }

  set setLga(String v) {
    lgaData = v;
    registrationModel.lgaG = v;
    notifyListeners();
  }

  clearFormAfterRegistration() {
    registrationModel = RegistrationModel();
    location = null;
    lgaData = null;
  }

  getAllLGA(String state) async {
    try {
      pageState = PageState.loading;
      LGAResponse lgaResponse = await AuthRepository.getAllGA({"state": state});

      if (lgaResponse.status == true) {
        allLgaData = lgaResponse.data;
      }
      if (allLgaData == null) {
        regAddressView?.onError("Get LGA failed");
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      regAddressView?.onError(e.toString());
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  getAllLocation() async {
    if (locationData == null) {
      try {
        pageState = PageState.loading;
        LocationResponse locationResponse = await AuthRepository.getAllState();
        if (locationResponse.status == true) {
          locationData = locationResponse.data;
        } else {
          regAddressView?.onError("Get State failed");
        }

        pageState = PageState.loaded;
        notifyListeners();
      } catch (e) {
        regAddressView?.onError(e.toString());
        pageState = PageState.loaded;
        notifyListeners();
      }
    }
  }

  register() async {
    print(registrationModel.toJson());
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result = await AuthRepository().signUP(registrationModel);
      if (result.status == true) {
        regPasswordView?.onSuccess(result.message ?? "");
      } else {
        regPasswordView?.onError(result.message!);
      }

      //clear form
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      //clear form

      pageState = PageState.loaded;
      notifyListeners();
      if (e is HttpException) {
        regPasswordView?.onError((e).getMessage);
        return;
      }
      regPasswordView?.onError((e).toString());
    }
  }

  otpVerification() async {
    Map data = isSelectPhoneVerification
        ? {"phone_no": registrationModel.phone, "code": otp}
        : {"email": registrationModel.email, "code": otp};
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result =
          await AuthRepository.verifyOTP(data, isSelectPhoneVerification);

      if (result.status == true) {
        _otpView.onVerify(result.message.toString());
      } else {
        _otpView.onError(result.message!);
      }
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
    Map data = isSelectPhoneVerification
        ? {"phone_no": registrationModel.phone}
        : {"email": registrationModel.email};

    pageState = PageState.loading;
    notifyListeners();
    AuthRepository.sendOTP(data, isSelectPhoneVerification).then((value) {
      if (value.status == true) {
        _requestOTPView.onSuccess(value.message.toString());
      } else {
        _requestOTPView.onError(value.message.toString());
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, i) {
      _requestOTPView.onError(error.toString());
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  resendOTP() async {
    Map data = isSelectPhoneVerification
        ? {"phone_no": PhoneNumber.format(registrationModel.phone!)}
        : {"email": registrationModel.email};

    pageState = PageState.loading;
    notifyListeners();
    AuthRepository.resSendOTP(data, isSelectPhoneVerification).then((value) {
      if (value.status == true) {
        _otpView.onSuccess(value.message.toString());
      } else {
        _otpView.onError(value.message.toString());
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, i) {
      _otpView.onError(error.toString());
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  void validateRegistrationPersonalForm() {
    if (isEmpty(registrationModel.gender)) {
      regPersonalView?.onError("Please select your Date of birth");
      return;
    } else if (isEmpty(registrationModel.dob)) {
      regPersonalView?.onError("Please select your Date of birth");
      return;
    } else if (isEmpty(registrationModel.firstName)) {
      regPersonalView?.onError("Please Enter your First Name");
      return;
    } else if (isEmpty(registrationModel.lastName)) {
      regPersonalView?.onError("Please Enter your First Name");
      return;
    }
    regPersonalView?.onFormValid();
  }

  void validateRegistrationAddressForm() {
    if (isEmpty(registrationModel.state)) {
      regAddressView?.onError("Please select  your State");
      return;
    } else if (isEmpty(registrationModel.lgaG)) {
      regAddressView?.onError("Please select your LGA");
      return;
    } else if (isEmpty(registrationModel.street)) {
      regAddressView?.onError("Please Enter your Address");
      return;
    }
    regAddressView?.onFormValid();
  }

  void validateRegistrationPasswordForm() {
    if (isEmpty(registrationModel.password)) {
      regPasswordView?.onError("Please enter your password");
      return;
    } else if (isEmpty(registrationModel.passwordConfirmation)) {
      regPasswordView?.onError("Please confirm your password");
      return;
    } else if (registrationModel.passwordConfirmation !=
        registrationModel.password) {
      regPasswordView?.onError("Your provided password mis-match");
      return;
    }
    regPasswordView?.onFormValid();
  }

  validateRequestOTPForm() {
    if (isSelectPhoneVerification) {
      if (!ValidationController().isValidPhoneNumber(registrationModel.phone)) {
        _requestOTPView.onError("Your phone number is not valid");
        return;
      }
    } else {
      if (ValidationController().validateEmail(registrationModel.email ?? "")) {
        _requestOTPView.onError("Your email address is not valid");
        return;
      }
    }
    _requestOTPView.onFormValid();
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

abstract class RequestOTPView {
  void onSuccess(String message);
  void onError(String message);
  void onFormValid();
}

abstract class REGView {
  void onError(String message);
  void onFormValid();
}

abstract class REGAddressView with REGView {}

abstract class REGPersonalView extends REGView {}

abstract class REGPasswordView extends REGView {
  void onRegister();
  void onSuccess(String message);
}

class RegView {
  REGAddressView? regAddressView;
  REGPersonalView? regPersonalView;
  REGPasswordView? regPasswordView;
  set setRegPersonal(v) {
    regPersonalView = v;
  }

  set setRegAddress(v) {
    regAddressView = v;
  }

  set setRegPassword(v) {
    regPasswordView = v;
  }
}

enum BasicPhoneEmailVerification {
  forRegistration,
  forAccountVerification,
}
