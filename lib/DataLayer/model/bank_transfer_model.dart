class BankTransferModel {
  String? amount;
  String? accountNumber;
  String? bankCode;
  String? wallet;
  String? narration;
  String? pin;
  String? customerName;
  String? receiverBank;
  String? longitude, latitude;
  bool? beneficiary;

  BankTransferModel(
      {this.amount,
      this.accountNumber,
      this.bankCode,
      this.wallet,
      this.narration,
      pin,
      this.customerName,
      this.receiverBank,
      this.latitude,
      this.longitude});

  BankTransferModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    accountNumber = json['account_number'];
    bankCode = json['code'];
    wallet = json['wallet'];
    narration = json['narration'];
    pin = json['pin'];
    customerName = json['customer_name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    receiverBank = json['receiver_bank'];
    beneficiary = json['beneficiary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['account_number'] = accountNumber;
    data['code'] = bankCode;
    data['wallet'] = wallet;
    data['narration'] = narration ?? "";
    data['pin'] = pin;
    data['customer_name'] = customerName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['receiver_bank'] = receiverBank;
    data['beneficiary'] = beneficiary;
    return data;
  }
}
