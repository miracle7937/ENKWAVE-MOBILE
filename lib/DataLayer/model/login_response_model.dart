class LoginResponseModel {
  bool? success;
  String? message;
  UserData? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? tokenType;
  String? token;
  String? id;
  String? name;
  String? phoneNumber;
  String? accountType;
  String? accountNumber;
  String? accountBalance;
  String? email;
  String? password;

  UserData(
      {this.tokenType,
      this.token,
      this.id,
      this.name,
      this.phoneNumber,
      this.accountType,
      this.accountNumber,
      this.accountBalance});

  UserData.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    token = json['token'];
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    accountType = json['account_type'];
    accountNumber = json['account_number'];
    accountBalance = json['account_balance'];
    email = json['email'];
    password = json['password'];
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
    data['account_balance'] = accountBalance;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
