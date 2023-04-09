class RegistrationModel {
  String? lastName;
  String? firstName;
  String? gender;
  String? phone;
  String? phoneCountry;
  String? accountType;
  String? password;
  String? pin;
  String? passwordConfirmation;
  String? email;
  String? lga;
  String? state;
  String? street;
  String? dob;

  RegistrationModel(
      {this.lastName,
      this.firstName,
      this.gender,
      this.phone,
      this.phoneCountry,
      this.accountType,
      this.password,
      this.passwordConfirmation,
      this.email,
      this.lga,
      this.state,
      this.pin,
      this.dob,
      this.street});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    lga = json['lga'];
    state = json['state'];
    street = json['street'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    phone = json['phone'];
    phoneCountry = json['phone_country'];
    accountType = json['account_type'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    email = json['email'];
    gender = json['gender'];
    pin = json['pin'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['phone_no'] = phone;
    data['phone_country'] = phoneCountry ?? "NG";
    data['account_type'] = accountType ?? "user";
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    data['email'] = email;
    data['gender'] = gender;
    data['street'] = street;
    data['state'] = state;
    data['lga'] = lga;
    data['pin'] = pin;
    data['dob'] = dob;
    return data;
  }
}
