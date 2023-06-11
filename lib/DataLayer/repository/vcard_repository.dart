import 'package:enk_pay_project/DataLayer/model/generic_model_response.dart';

import '../../Constant/routes.dart';
import '../model/card_details_model.dart';
import '../request.dart';

class VCardRepository {
  static Future<GenericResponse> verifyImage(
      List<FileKeyValue>? uploadFile) async {
    var responseData = await ServerRequest().uploadFile(
        path: AppRoute.verifyIdentityCardRoute,
        body: {},
        fileKeyValue: uploadFile);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<GenericResponse> fundCard(Map map) async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.fundCardRoute, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<GenericResponse> blockCard(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.blockCardRoute, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<GenericResponse> unBlockCard(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.unBlockCardRoute, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<GenericResponse> liquidateCard(Map map) async {
    var responseData = await ServerRequest()
        .postData(path: AppRoute.liquidateCardRoute, body: map);
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<GenericResponse> createVCard() async {
    var responseData =
        await ServerRequest().postData(path: AppRoute.createCard, body: {});
    return GenericResponse.fromJson(responseData.data);
  }

  static Future<CardDetailsResponse> getCardsDetail() async {
    var responseData =
        await ServerRequest().getData(path: AppRoute.cardDetails);
    return CardDetailsResponse.fromJson(responseData.data);
  }
}
