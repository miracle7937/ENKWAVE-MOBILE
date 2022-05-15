import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';

class MtnMobileDataModel extends BasePackage {
  String? amount;
  String? data;
  String? dataName;
  String? description;

  MtnMobileDataModel({this.amount, this.data, this.dataName, this.description});

  MtnMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['mtn_data_amount'];
    data = json['mtn_data_type'];
    dataName = json['mtn_data_name'];
    description = json['mtn_data_description'];
    super.setValue(amount!, description!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mtn_data_amount'] = amount;
    data['mtn_data_type'] = this.data;
    data['mtn_data_name'] = dataName;
    data['mtn_data_description'] = description;
    return data;
  }
}
