class ValidateBillModel {
  String? billerId;
  String? customerId;
  String? serviceId;

  ValidateBillModel({this.billerId, this.customerId, this.serviceId});

  ValidateBillModel.fromJson(Map<String, dynamic> json) {
    billerId = json['billerID'];
    customerId = json['customerID'];
    serviceId = json['serviceID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billerID'] = billerId;
    data['customerId'] = customerId;
    data['serviceId'] = serviceId;
    return data;
  }
}
