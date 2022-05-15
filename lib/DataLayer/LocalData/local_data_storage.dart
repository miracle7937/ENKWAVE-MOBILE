import 'dart:convert';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalDataStorage {
  static const _storage = FlutterSecureStorage();

  static saveUserData(UserData? userData) {
    _storage.write(
      key: ConstantString.userDataKey,
      value: json.encode(userData!.toJson()),
    );
  }

  static Future<String?> getToken() async {
    String? value = await _storage.read(
      key: ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).token;
    }
    return null;
  }

  static Future<String?> getUserUUID() async {
    String? value = await _storage.read(
      key: ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).id;
    }
    return null;
  }

  static Future<String?> getPhone() async {
    String? value = await _storage.read(
      key: ConstantString.userDataKey,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserData.fromJson(map).phoneNumber;
    }
    return null;
  }

  static saveHideBalance(bool hide) {
    _storage.write(
      key: ConstantString.hideBalance,
      value: hide.toString(),
    );
  }

  static Future<bool> getHideBalance() async {
    String? value = await _storage.read(key: ConstantString.hideBalance);
    bool hide = (value == "false" || value == null) ? false : true;
    return hide;
  }

  static saveEnableBiometric(bool hide) {
    _storage.write(
      key: ConstantString.enableBiometric,
      value: hide.toString(),
    );
  }

  static Future<bool> getBiometricStatus() async {
    String? value = await _storage.read(key: ConstantString.enableBiometric);
    bool isEnable = (value == "false" || value == null) ? false : true;
    return isEnable;
  }

  //user creditential
  static saveUserCredential(UserCredentialModel? userCredentialModel) {
    _storage.write(
      key: ConstantString.credential,
      value: json.encode(userCredentialModel!.toJson()),
    );
  }

  static Future<UserCredentialModel?> getUserCredential() async {
    String? value = await _storage.read(
      key: ConstantString.credential,
    );
    Map<String, dynamic> map = value != null ? json.decode(value) : {};
    if (map.isNotEmpty) {
      return UserCredentialModel.fromJson(map);
    }
    return null;
  }
}
