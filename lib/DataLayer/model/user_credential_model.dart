class UserCredentialModel {
  String? email;
  String? password;
  String? phone;
  String? token;
  String? deviceIdentifier;
  String? deviceName;

  UserCredentialModel({this.email, this.password, this.phone});

  UserCredentialModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    token = json['device_id'];
    deviceIdentifier = json['deviceIdentifier'];
    deviceName = json['deviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['device_id'] = token;
    data['deviceIdentifier'] = deviceIdentifier;
    data['deviceName'] = deviceName;
    return data;
  }
}
