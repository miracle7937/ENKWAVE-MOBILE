class BankTransferModel {
  String? amount;
  String? destinationAccount;
  String? destinationBankCode;

  BankTransferModel(
      {this.amount, this.destinationAccount, this.destinationBankCode});

  BankTransferModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    destinationAccount = json['destination_account'];
    destinationBankCode = json['destination_bank_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = this.amount;
    data['destination_account'] = destinationAccount;
    data['destination_bank_code'] = destinationBankCode;
    return data;
  }
}
