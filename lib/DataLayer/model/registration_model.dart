class RegistrationModel {
  String? lastName;
  String? firstName;
  String? middleName;
  String? phone;
  String? phoneCountry;
  String? accountType;
  String? password;
  String? passwordConfirmation;
  String? email;

  RegistrationModel(
      {this.lastName,
      this.firstName,
      this.middleName,
      this.phone,
      this.phoneCountry,
      this.accountType,
      this.password,
      this.passwordConfirmation,
      this.email});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    phone = json['phone'];
    phoneCountry = json['phone_country'];
    accountType = json['account_type'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['phone'] = phone;
    data['phone_country'] = phoneCountry ?? "NG";
    data['account_type'] = accountType ?? "user";
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    data['email'] = email;
    return data;
  }
}
