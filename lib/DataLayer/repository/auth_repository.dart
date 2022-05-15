import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_model.dart';
import 'package:enk_pay_project/DataLayer/model/registration_response.dart';

import '../request.dart';

class AuthRepository {
  Future<RegistrationResponse> signUP(
      RegistrationModel registrationModel) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.signUp, body: registrationModel.toJson());
    return RegistrationResponse.fromJson(responseData.data);
  }

  Future<LoginResponseModel> login(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.logIN, body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> sendOTP(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.sendOTP, body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }

  static Future<LoginResponseModel> verifyOTP(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.otpVerification, body: map);
    return LoginResponseModel.fromJson(responseData.data);
  }
}
