class AirtimeModel {
  String? phone;
  String? amount;
  String? uuid;
  String? token;

  AirtimeModel({this.phone, this.amount, this.uuid, this.token});

  AirtimeModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    amount = json['amount'];
    uuid = json['uuid'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['amount'] = amount;
    data['uuid'] = uuid;
    data['token'] = token;
    return data;
  }
}
