import 'base_package.dart';

class GloMobileDataModel extends BasePackage {
  String? amount;
  String? dataCode;
  String? dataName;
  String? description;

  GloMobileDataModel(
      {this.dataCode, this.amount, this.dataName, this.description});

  GloMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['variation_amount'];
    dataCode = json['variation_code'];
    dataName = json['name'];
    description = json['name'];
    super.setValue(amount!, description!, dataCode!, "glo-data");
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
