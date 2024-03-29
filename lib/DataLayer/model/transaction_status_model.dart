class TransactionStatusModel {
  int? status;
  String? eRef;
  int? amount;
  String? receiverBank, receiverAccountNo, receiverName;
  String? message, date, note;
  String? cardPan, rrn;

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
    cardPan = json['card_pan'];
    rrn = json['rrn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = statusString(status);
    data['e_ref'] = eRef;
    data['amount'] = amount.toString();
    data['receiver_bank'] = receiverBank;
    data['message'] = message;
    data['receiver_account_no'] = receiverAccountNo;
    data['rrn'] = rrn;
    data['card_pan'] = cardPan;
    return data;
  }

  String statusString(num? status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Successful";
      default:
        return "Reversed";
    }
  }
}
