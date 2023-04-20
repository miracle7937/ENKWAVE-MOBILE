class TransactionStatusModel {
  int? status;
  String? eRef;
  int? amount;
  String? receiverBank, receiverAccountNo, receiverName;
  String? message, date, note;

  TransactionStatusModel(
      {this.status, this.eRef, this.amount, this.receiverBank, this.message});

  TransactionStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    eRef = json['e_ref'];
    amount = json['amount'];
    receiverBank = json['receiver_bank'];
    message = json['message'];
    receiverAccountNo = json['receiver_account_no'];
    receiverName = json['receiver_name'];
    note = json['note'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['e_ref'] = eRef;
    data['amount'] = amount;
    data['receiver_bank'] = receiverBank;
    data['message'] = message;
    data['receiver_account_no'] = receiverAccountNo;
    data['receiver_name'] = receiverName;
    return data;
  }
}
