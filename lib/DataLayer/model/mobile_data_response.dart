class MobileDataResponse {
  bool? status;
  Data? data;

  MobileDataResponse({this.status, this.data});

  MobileDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? responseCode;
  String? responseMessage;
  String? transRef;
  Null? responseData;
  Null? userAcct;
  Null? acctBalance;

  Data(
      {this.responseCode,
      this.responseMessage,
      this.transRef,
      this.responseData,
      this.userAcct,
      this.acctBalance});

  Data.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    transRef = json['transRef'];
    responseData = json['responseData'];
    userAcct = json['userAcct'];
    acctBalance = json['acctBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['transRef'] = this.transRef;
    data['responseData'] = this.responseData;
    data['userAcct'] = this.userAcct;
    data['acctBalance'] = this.acctBalance;
    return data;
  }
}
