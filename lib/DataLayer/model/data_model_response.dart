class DataModelResponse {
  bool? status;
  String? responseCode;
  String? message;
  List<AirtimeDataPlan>? data;

  DataModelResponse({this.status, this.responseCode, this.message, this.data});

  DataModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responseCode = json['responseCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AirtimeDataPlan>[];
      json['data'].forEach((v) {
        data!.add(AirtimeDataPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['responseCode'] = responseCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AirtimeDataPlan {
  String? productId;
  String? dataBundle;
  String? amount;
  String? validity;

  AirtimeDataPlan(
      {this.productId, this.dataBundle, this.amount, this.validity});

  AirtimeDataPlan.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    dataBundle = json['dataBundle'];
    amount = json['amount'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['dataBundle'] = dataBundle;
    data['amount'] = amount;
    data['validity'] = validity;
    return data;
  }
}
