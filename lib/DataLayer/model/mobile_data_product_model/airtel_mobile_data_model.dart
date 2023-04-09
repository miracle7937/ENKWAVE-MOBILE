import 'base_package.dart';

class AirtelMobileDataModel extends BasePackage {
  String? amount;
  String? dataCode;
  String? description;

  AirtelMobileDataModel({this.amount, this.dataCode, this.description});

  AirtelMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['variation_amount'];
    dataCode = json['variation_code'];
    description = json['name'];
    super.setValue(amount!, description!, dataCode!, "airtel-data");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['variation_amount'] = amount;
    map['variation_code'] = dataCode;
    map['name'] = description;
    return map;
  }
}
