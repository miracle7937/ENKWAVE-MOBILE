class InAppModelData {
  String? phoneNumber;
  String? amount;
  String? description;

  InAppModelData({this.phoneNumber, this.amount, this.description});

  InAppModelData.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    amount = json['amount'];
    description = json['description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phoneNumber;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
