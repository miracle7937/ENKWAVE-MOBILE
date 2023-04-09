import '../../Constant/string_values.dart';

class LookData {
  String? billerCode;
  String? serviceId;
  String? type;

  LookData({this.billerCode, this.serviceId, this.type});

  LookData.fromJson(Map<String, dynamic> json) {
    billerCode = json['biller_code'];
    serviceId = json['service_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['biller_code'] = billerCode;
    data['service_id'] = serviceId;
    data['type'] = type;
    return data;
  }

  isValid() =>
      isNotEmpty(billerCode) && isNotEmpty(serviceId) && isNotEmpty(type);
}
