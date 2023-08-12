import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';

import '../model/generic_model_response.dart';
import '../model/lga_response.dart';
import '../model/location_response.dart';
import '../request.dart';

class AuthRepository {
  Future<RegistrationResponse> signUP(
      RegistrationModel registrationModel) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.signUp, body: registrationModel.toJson());
    return RegistrationResponse.fromJson(responseData.data);
  }

  Future<LoginResponseModel> login(Map map, {bool phoneLogin = true}) async {
    var responseData = await ServerRequest().postData(
        path: phoneLogin ? AppRoute.logINPhone : AppRoute.logINEmail,
        body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> sendOTP(
      Map map, bool isSelectPhoneVerification) async {
    var responseData = await ServerRequest().postData(
        path: isSelectPhoneVerification
            ? AppRoute.sendOTPPhone
            : AppRoute.sendOTPEmil,
        body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> resSendOTP(
      Map map, bool isSelectPhoneVerification) async {
    var responseData = await ServerRequest().postData(
        path: isSelectPhoneVerification
            ? AppRoute.reSendOTPPhone
            : AppRoute.sendOTPEmil,
        body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> resSendOTPForDeviceVerification(
      Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.resSendOTPEmil, body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> sendOTPAuthenticatedUser(
      Map map, bool isSelectPhoneVerification) async {
    var responseData = await ServerRequest().postData(
        path: isSelectPhoneVerification
            ? AppRoute.sendOTPPhoneAuthUser
            : AppRoute.sendOTPEmailAuthUser,
        body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> verifyOTP(
      Map map, bool isSelectPhoneVerification) async {
    var responseData = await ServerRequest().postData(
        path: isSelectPhoneVerification
            ? AppRoute.otpVerificationPhone
            : AppRoute.otpVerificationEmail,
        body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<GenericResponse> otpUpdateDevice(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.otpUpdateDevice, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<LocationResponse> getAllState() async {
    var response = await ServerRequest().getData(path: AppRoute.getAllState);
    return LocationResponse.fromJson(response.data);
  }

  static Future<LGAResponse> getAllGA(Map data) async {
    var response =
        await ServerRequest().postData(path: AppRoute.getLga, body: data);
    return LGAResponse.fromJson(response.data);
  }

  static Future<GenericResponse> verifyPin(Map<String, dynamic> map) async {
    var response =
        await ServerRequest().postData(path: AppRoute.verifyPin, body: map);
    return GenericResponse.fromJson(response.data);
  }

  static Future<GenericResponse> logOut() async {
    var response =
        await ServerRequest().postData(path: AppRoute.logout, body: {});
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> forgetPassword(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.forgotForgot, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> deleteAccount() async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.deleteUser);
    return GenericResponse.fromJson(responseData.data);
  }
}
