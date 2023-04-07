import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../model/contact_us_model.dart';
import '../model/request_device_model.dart';
import '../request.dart';

class SettingRepository {
  Future<ContactUsModel> contact() async {
    var responseData = await ServerRequest().getData(path: AppRoute.contact);
    return ContactUsModel.fromJson(responseData.data);
  }

  Future<RequestDeviceResponse> requestDevice(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.orderDevice, body: map);
    return RequestDeviceResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> orderDeviceComplete(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.orderDeviceComplete, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<RequestDeviceResponse> updateAccountInfo(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.updateBankInfo, body: map);
    return RequestDeviceResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> bvnAndNINVerification(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.verifyIdentity, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> uploadIdentity(List<FileKeyValue>? uploadFile) async {
    var responseData = await ServerRequest().uploadFile(
        path: AppRoute.uploadIdentity, body: {}, fileKeyValue: uploadFile);
    return GenericResponse.fromJson(responseData.data);
  }
}
