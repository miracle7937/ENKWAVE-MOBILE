import 'dart:convert';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataStorage {
  // static const _storage = FlutterSecureStorage();

  static saveUserData(UserData? userData) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.userDataKey,
      json.encode(userData!.toJson()),
    );
  }

  static Future<UserData?> getUserData() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map);
    }
    return null;
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).email;
    }
    return null;
  }

  static saveUserAppSettings(AppSettings? appSettings) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.appSettings,
      json.encode(appSettings?.toJson()),
    );
  }

  static Future<AppSettings?> getUserAppSettings() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    AppSettings? appSettings;
    String? value = _storage.getString(
      ConstantString.appSettings,
    );
    if (value != null) {
      appSettings = AppSettings.fromJson(jsonDecode(value));
    }
    return appSettings;
  }

  static saveTerminalConfig(TerminalConfig? terminalConfig) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.terminalConfig,
      json.encode(terminalConfig?.toJson()),
    );
  }

  static Future<TerminalConfig?> getTerminalConfig() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    TerminalConfig? terminalConfig;
    String? value = _storage.getString(
      ConstantString.terminalConfig,
    );
    if (value != null) {
      terminalConfig = TerminalConfig.fromJson(jsonDecode(value));
    }
    return terminalConfig;
  }

  static saveUserPermission(APPPermission? featurePermission) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.userPermission,
      json.encode(featurePermission?.toJson()),
    );
  }

  static Future<APPPermission?> getUserPermission() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    APPPermission? featurePermission;
    String? value = _storage.getString(
      ConstantString.userPermission,
    );
    if (value != null) {
      featurePermission = APPPermission.fromJson(jsonDecode(value));
    }
    return featurePermission;
  }

  static Future<String?> getToken() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.userDataKey,
    );

    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).token;
    }
    return null;
  }

  static Future<String?> getUserUUID() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).id.toString();
    }
    return null;
  }

  static Future<String?> getPhone() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).phone;
    }
    return null;
  }

  static saveHideBalance(bool hide) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.hideBalance,
      hide.toString(),
    );
  }

  static Future<bool> getHideBalance() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(ConstantString.hideBalance);
    bool hide = (value == "false" || value == null) ? false : true;
    return hide;
  }

  static saveHideBonus(bool hide) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.hideBonus,
      hide.toString(),
    );
  }

  static Future<bool> getHideBonus() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(ConstantString.hideBonus);
    bool hide = (value == "false" || value == null) ? false : true;
    return hide;
  }

  static saveEnableBiometric(bool hide) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    _storage.setString(
      ConstantString.enableBiometric,
      hide.toString(),
    );
  }

  static Future<bool> getBiometricStatus() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(ConstantString.enableBiometric);
    bool isEnable = (value == "false" || value == null) ? false : true;
    return isEnable;
  }

  //user creditential
  static saveUserCredential(UserCredentialModel? userCredentialModel) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.setString(
      ConstantString.credential,
      json.encode(userCredentialModel!.toJson()),
    );
  }

  static Future<UserCredentialModel?> getUserCredential() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    String? value = _storage.getString(
      ConstantString.credential,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserCredentialModel.fromJson(map);
    }
    return null;
  }

  static Future clearUser() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    return _storage.remove(
      ConstantString.userDataKey,
    );
  }
}
