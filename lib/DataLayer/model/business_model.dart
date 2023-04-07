import 'package:enk_pay_project/Constant/string_values.dart';

class BusinessModel {
  String? name;
  String? address;
  String? number;

  BusinessModel({this.name, this.address, this.number});

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      name: json['b_name'] ?? '',
      address: json['b_address'] ?? '',
      number: json['b_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['b_name'] = name;
    data['b_address'] = address;
    data['b_number'] = number;
    return data;
  }

  isValid() => isNotEmpty(name) && isNotEmpty(address);
}
