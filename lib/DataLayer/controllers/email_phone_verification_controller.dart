import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/validation.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../repository/auth_repository.dart';

class EmailPhoneVerificationController with ChangeNotifier {
  RequestOTPView? _requestOTPView;
  OTPAuthUserView? _otpView;
  bool isSelectPhoneVerification = true;
  PageState pageState = PageState.loaded;
  String? phone, email, otp;

  setIsPhoneVerification(bool v) {
    isSelectPhoneVerification = v;
  }

  set requestOTPView(v) {
    _requestOTPView = v;
  }

  set otpView(OTPAuthUserView v) {
    _otpView = v;
  }

  validateRequestOTPForm() {
    if (isSelectPhoneVerification) {
      if (!ValidationController().isValidPhoneNumber(phone)) {
        _requestOTPView?.onError("Your phone number is not valid");
        return;
      }
    } else {
      if (ValidationController().validateEmail(email ?? "")) {
        _requestOTPView?.onError("Your email address is not valid");
        return;
      }
    }
    _requestOTPView?.onFormValid();
  }

  sentAuthUserOTP() async {
    Map data = isSelectPhoneVerification
        ? {"phone_no": PhoneNumber.format(phone!)}
        : {"email": email};

    pageState = PageState.loading;
    notifyListeners();
    AuthRepository.sendOTPAuthenticatedUser(data, isSelectPhoneVerification)
        .then((value) {
      if (value.status == true) {
        _requestOTPView?.onSuccess(value.message.toString());
      } else {
        _requestOTPView?.onError(value.message.toString());
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, i) {
      _requestOTPView?.onError(error.toString());
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  resendAuthUserOTP() async {
    Map data = isSelectPhoneVerification
        ? {"phone_no": PhoneNumber.format(phone!)}
        : {"email": email};

    pageState = PageState.loading;
    notifyListeners();
    AuthRepository.sendOTPAuthenticatedUser(data, isSelectPhoneVerification)
        .then((value) {
      if (value.status == true) {
        _otpView?.onSuccess(value.message.toString());
      } else {
        _otpView?.onError(value.message.toString());
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, i) {
      _otpView?.onError(error.toString());
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  otpVerification() async {
    Map data = isSelectPhoneVerification
        ? {"phone_no": PhoneNumber.format(phone!), "code": otp}
        : {"email": email, "code": otp};
    try {
      pageState = PageState.loading;
      notifyListeners();
      var result =
          await AuthRepository.verifyOTP(data, isSelectPhoneVerification);

      if (result.status == true) {
        _otpView?.onVerify(result.message.toString());
      } else {
        _otpView?.onError(result.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      _otpView?.onError((e).toString());
    }
  }

  void setPhone(String v) {
    phone = v;
  }

  void setEmail(String v) {
    email = v;
  }

  void setOTp(String v) {
    otp = v;
  }
}

abstract class RequestOTPView {
  void onSuccess(String message);
  void onError(String message);
  void onFormValid();
}

abstract class OTPAuthUserView {
  void onSuccess(String message);
  void onError(String message);
  void onVerify(String message);
}
