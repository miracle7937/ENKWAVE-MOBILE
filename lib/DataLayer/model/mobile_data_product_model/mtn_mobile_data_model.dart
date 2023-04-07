import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';

class MtnMobileDataModel extends BasePackage {
  String? amount;
  String? dataCode;
  String? dataName;
  String? description;

  MtnMobileDataModel(
      {this.amount, this.dataCode, this.dataName, this.description});

  MtnMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['variation_amount'];
    dataCode = json['variation_code'];
    dataName = json['name'];
    description = json['name'];
    super.setValue(amount!, description!, dataCode!, "mtn-data");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_amount'] = amount;
    data['variation_code'] = dataCode;
    data['name'] = dataName;
    data['name'] = description;
    return data;
  }
}
