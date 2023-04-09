class RegistrationResponse {
  bool? status;
  String? message;
  Data? data;

  RegistrationResponse({this.status, this.message, this.data});

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? tokenType;
  String? token;
  String? id;
  String? name;
  String? phoneNumber;
  String? accountType;
  String? accountNumber;

  Data(
      {this.tokenType,
      this.token,
      this.id,
      this.name,
      this.phoneNumber,
      this.accountType,
      this.accountNumber});

  Data.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    token = json['token'];
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    accountType = json['account_type'];
    accountNumber = json['account_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['token'] = token;
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['account_type'] = accountType;
    data['account_number'] = accountNumber;
    return data;
  }
}
