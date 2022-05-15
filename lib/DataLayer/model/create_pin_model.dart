class CreatePinModel {
  String? phone;
  String? pin;
  String? pinConfirmation;

  CreatePinModel({this.phone, this.pin, this.pinConfirmation});

  CreatePinModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    pin = json['pin'];
    pinConfirmation = json['pin_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['pin'] = pin;
    data['pin_confirmation'] = pinConfirmation;
    return data;
  }
}
