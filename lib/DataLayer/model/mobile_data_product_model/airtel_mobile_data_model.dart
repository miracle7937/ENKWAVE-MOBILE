import 'base_package.dart';

class AirtelMobileDataModel extends BasePackage {
  String? amount;
  String? data;
  String? description;

  AirtelMobileDataModel({this.amount, this.data, this.description});

  AirtelMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['airtel_data_amount'];
    data = json['airtel_data'];
    description = json['airtel_data_description'];
    super.setValue(amount!, description!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['airtel_data_amount'] = amount;
    map['airtel_data'] = data;
    map['airtel_data_description'] = description;
    return map;
  }
}
