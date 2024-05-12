import '../../Constant/routes.dart';
import '../model/bill_form_response.dart';
import '../model/biller_response.dart';
import '../model/generic_model_response.dart';
import '../request.dart';

class BillRepository {
  Future<GenericResponse> buyBill(Map body) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.payBill, body: body);
    return GenericResponse.fromJson(responseData.data);
  }

  Future<BillResponse> getBill(String id) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.getBiller, body: {"biller_id": id});
    return BillResponse.fromJson(responseData.data);
  }

  Future<BillFormResponse> getBillForm(String id) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.getBillerType, body: {"biller_type_id": id});
    return BillFormResponse.fromJson(responseData.data);
  }
}
