class BuyDataModel {
  String? wallet;
  String? amount;
  String? variationCode;
  String? productId;
  String? phone;
  String? pin;
  String? network;

  BuyDataModel({wallet, amount, variationCode, serviceId, phone, pin});

  BuyDataModel.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
    amount = json['amount'];
    variationCode = json['variation_code'];
    productId = json['product_id'];
    phone = json['phone'];
    pin = json['pin'];
    network = json['network'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    data['amount'] = amount;
    data['variation_code'] = variationCode;
    data['product_id'] = productId;
    data['phoneNumber'] = phone;
    data['pin'] = pin;
    data['network'] = network;
    return data;
  }
}
