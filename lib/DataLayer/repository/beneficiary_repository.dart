import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../model/beneficiary_response_model.dart';
import '../request.dart';

class BeneficiaryRepository {
  Future<BeneficiaryRespModel> getBeneficiary() async {
    var responseData =
        await ServerRequest().getData(path: AppRoute.getBeneficiary);
    return BeneficiaryRespModel.fromJson(responseData.data);
  }

  Future<GenericResponse> deleteBeneficiary(String id) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.deleteBeneficiary, body: {"id": id});
    return GenericResponse.fromJson(responseData.data);
  }

  Future<GenericResponse> editBeneficiary(String id, String name) async {
    var responseData = await ServerRequest().postData(
        path: AppRoute.updateBeneficiary,
        body: {"id": id, "customer_name": name});
    return GenericResponse.fromJson(responseData.data);
  }
}
