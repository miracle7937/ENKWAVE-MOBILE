class UserCredentialModel {
  String? email;
  String? password;
  String? phone;

  UserCredentialModel({this.email, this.password, this.phone});

  UserCredentialModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    return data;
  }
}
