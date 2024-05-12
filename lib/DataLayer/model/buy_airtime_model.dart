class BuyAirtimeModel {
  String? wallet;
  String? amount;
  String? serviceId;
  String? phone;
  String? pin;

  BuyAirtimeModel({
    wallet,
    amount,
    variationCode,
    serviceId,
    phone,
    pin,
  });

  BuyAirtimeModel.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
    amount = json['amount'];
    serviceId = json['service_id'];
    phone = json['phone'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    data['amount'] = amount;
    data['network'] = serviceId;
    data['phone'] = phone;
    data['pin'] = pin;
    return data;
  }
}
