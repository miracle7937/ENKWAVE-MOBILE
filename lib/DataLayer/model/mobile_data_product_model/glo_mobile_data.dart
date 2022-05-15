import 'base_package.dart';

class GloMobileDataModel extends BasePackage {
  String? amount;
  String? data;
  String? dataName;
  String? description;

  GloMobileDataModel({this.data, this.amount, this.dataName, this.description});

  GloMobileDataModel.fromJson(Map<String, dynamic> json) {
    amount = json['glo_data_amount'];
    data = json['glo_data'];
    dataName = json['glo_data_name'];
    description = json['glo_data_description'];
    super.setValue(amount!, description!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['glo_data_amount'] = amount;
    data['glo_data'] = this.data;
    data['glo_data_name'] = dataName;
    data['glo_data_description'] = description;
    return data;
  }
}
