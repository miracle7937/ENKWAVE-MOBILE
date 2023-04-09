class InAppModelData {
  String? phone;
  String? amount;
  String? wallet;
  String? pin;
  String? narration;

  InAppModelData({phone, amount, wallet, pin, narration});

  InAppModelData.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    amount = json['amount'];
    wallet = json['wallet'];
    pin = json['pin'];
    narration = json['narration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['amount'] = amount;
    data['wallet'] = wallet;
    data['pin'] = pin;
    data['narration'] = narration ?? "";
    return data;
  }
}
