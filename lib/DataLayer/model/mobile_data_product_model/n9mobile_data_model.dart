import 'base_package.dart';

class N9MobileDataModel extends BasePackage {
  String? amount;
  String? data;
  String? description;

  N9MobileDataModel({this.amount, this.data, this.description});

  N9MobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['9mobile_data_amount'];
    data = json['9mobile_data'];
    description = json['9mobile_data_description'];
    super.setValue(amount!, data!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['9mobile_data_amount'] = amount;
    data['9mobile_data'] = this.data;
    data['9mobile_data_description'] = description;
    return data;
  }
}
