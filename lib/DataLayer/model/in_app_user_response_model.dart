class InAppUserResponseModel {
  bool? status;
  String? customerName;
  String? message;

  InAppUserResponseModel({this.status, this.customerName, this.message});

  InAppUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    customerName = json['customer_name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['customer_name'] = customerName;
    data['message'] = message;
    return data;
  }
}
