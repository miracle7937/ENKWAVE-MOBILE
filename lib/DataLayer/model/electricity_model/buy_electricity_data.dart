class BuyElectricityModel {
  String? wallet;
  String? amount;
  String? variationCode;
  String? serviceId;
  String? phone;
  String? pin;

  BuyElectricityModel({wallet, amount, variationCode, serviceId, phone, pin});

  BuyElectricityModel.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
    amount = json['amount'];
    variationCode = json['variation_code'];
    serviceId = json['service_id'];
    phone = json['phone'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    data['amount'] = amount;
    data['variation_code'] = variationCode;
    data['service_id'] = serviceId;
    data['phone'] = phone;
    data['pin'] = pin;
    return data;
  }
}
