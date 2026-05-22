import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../Constant/string_values.dart';
import 'branding_controller.dart';
import '../../core/whitelabel/organization_request_fields.dart';
import '../../Constant/validation.dart';
import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../UILayer/utils/device_info.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../../UILayer/utils/sync_keys.dart';
import '../../services/navigation_service.dart';
import '../LocalData/local_data_storage.dart';
import '../services/session_sync_service.dart';
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
  PinSignInView? _pinSignInView;

  late bool loginWithPhoneNumber = true;

  set forgetView(ForgetPasswordView forgetPasswordView) {
    _forgetPasswordView = forgetPasswordView;
  }

  set pinView(PinSignInView pinSignInView) {
    _pinSignInView = pinSignInView;
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

  saveData(LoginResponseModel result) async {
    await SessionSyncService.persist(result);
    await LocalDataStorage.saveUserPermission(result.permission);
    await LocalDataStorage.saveUserAppSettings(result.appSettings);
    await _refreshBrandingFromLogin(result);
    try {
      final ctx = NavigationService.navigatorKey.currentContext;
      if (ctx != null) {
        SyncKeys().init(ctx, showLoader: false);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final deferred = NavigationService.navigatorKey.currentContext;
          if (deferred != null) {
            SyncKeys().init(deferred, showLoader: false);
          }
        });
      }
    } catch (e) {
      log("Injecting logs fails======================> ${e}");
    }
  }

  Future<void> _refreshBrandingFromLogin(LoginResponseModel result) async {
    final businessId = result.data?.organizationBusinessId;
    if (businessId == null || businessId.isEmpty) return;
    try {
      final ctx = NavigationService.navigatorKey.currentContext;
      if (ctx == null) return;
      await ctx.read<BrandingController>().loadByBusinessId(businessId, silent: true);
    } catch (e) {
      log('Branding refresh after login: $e');
    }
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

    String? token = "";
    // String? token = await FirebaseMessaging.instance.getToken();
    userCredentialModel.token = token;
    data["token"] = token;

    String? deviceID = await DeviceInfo.getDeviceID();
    String? deviceName = await DeviceInfo.getDeviceName();
    userCredentialModel.deviceIdentifier = deviceID;
    userCredentialModel.deviceName = deviceName;
    LocalDataStorage.saveUserCredential(userCredentialModel);
    loginLogic(userCredentialModel);
  }

  Map<String, dynamic> _withOrganizationContext(Map data) {
    final payload = Map<String, dynamic>.from(data);
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx != null) {
      payload.addAll(
        organizationRequestFields(ctx.read<BrandingController>()),
      );
    }
    return payload;
  }

  loginLogic(UserCredentialModel? credentialModel) async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      credentialModel?.deviceIdentifier = "";
      final body = _withOrganizationContext(credentialModel!.toJson());
      var result = await AuthRepository()
          .login(body, phoneLogin: loginWithPhoneNumber);
      if (result.status == true) {
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

  pinSignIn(String pin) async {
    try {
      UserData? userData = await LocalDataStorage.getUserData();
      pageState = PageState.loading;
      notifyListeners();

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

      data["pin"] = pin;

      String? token = "";
      userCredentialModel.token = token;
      data["token"] = token;

      var result = await AuthRepository().pinLogin(_withOrganizationContext(data));
      if (result.status == true) {
        //save user
        saveData(result);
        _pinSignInView?.onSuccess(result.message ?? "");
      } else {
        _pinSignInView?.onError(result.message ?? "");
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
}

abstract mixin class LOGINView {
  void onSuccess(String message);
  void onError(String message);
  void onNewDevice(String message);
  void onSetUserCredential(UserCredentialModel userCredentialModel);
  void onValidate();
}

abstract mixin class ForgetPasswordView {
  void onSuccess(String message);
  void onError(String message);
}

abstract mixin class PinSignInView {
  void onSuccess(String message);
  void onError(String message);
}
