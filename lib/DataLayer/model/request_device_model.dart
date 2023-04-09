class RequestDeviceResponse {
  bool? status;
  String? message;
  String? paymentRef;
  Bank? bank;
  String? amount;

  RequestDeviceResponse(
      {this.status, this.message, this.paymentRef, this.bank, this.amount});

  RequestDeviceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    paymentRef = json['payment_ref'];
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['payment_ref'] = this.paymentRef;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    data['amount'] = this.amount;
    return data;
  }
}

class Bank {
  int? id;
  String? accountNo;
  String? accountName;
  String? bankName;

  Bank({this.id, this.accountNo, this.accountName, this.bankName});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountNo = json['account_no'];
    accountName = json['account_name'];
    bankName = json['bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account_no'] = this.accountNo;
    data['account_name'] = this.accountName;
    data['bank_name'] = this.bankName;
    return data;
  }
}
