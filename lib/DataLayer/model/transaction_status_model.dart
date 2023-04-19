class TransactionStatusModel {
  int? status;
  String? eRef;
  int? amount;
  String? receiverBank, receiverAccountNo, receiverName;
  String? message;

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['e_ref'] = this.eRef;
    data['amount'] = this.amount;
    data['receiver_bank'] = this.receiverBank;
    data['message'] = this.message;
    data['receiver_account_no'] = this.receiverAccountNo;
    data['receiver_name'] = this.receiverName;
    return data;
  }
}
