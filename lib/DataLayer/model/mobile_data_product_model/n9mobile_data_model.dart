import 'base_package.dart';

class N9MobileDataModel extends BasePackage {
  String? amount;
  String? dataCode;
  String? description;

  N9MobileDataModel({this.amount, this.dataCode, this.description});

  N9MobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json["variation_amount"];
    dataCode = json["variation_code"];
    description = json["name"];
    super.setValue(amount!, description!, dataCode!, "etisalat-data");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_amount'] = amount;
    data['variation_code'] = dataCode;
    data['name'] = description;
    return data;
  }
}
