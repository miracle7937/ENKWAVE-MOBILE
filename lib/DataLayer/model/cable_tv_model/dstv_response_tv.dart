import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';

class DsTvResponseModel extends BasePackage {
  String? variationCode;
  String? name;
  String? variationAmount;
  String? fixedPrice;

  DsTvResponseModel.fromJson(Map<String, dynamic> json) {
    variationCode = json['variation_code'];
    name = json['name'];
    variationAmount = json['variation_amount'];
    fixedPrice = json['fixedPrice'];
    super.setValue(variationAmount!, name!, variationCode!, "dstv");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_code'] = variationCode;
    data['name'] = name;
    data['variation_amount'] = variationAmount;
    data['fixedPrice'] = fixedPrice;
    return data;
  }
}
