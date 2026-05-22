class EODFullReportModel {
  bool? status;
  String? reportDatetime;
  String? terminalNo;
  String? merchantName;
  String? merchantNo;
  int? totalTransaction;
  int? totalSuccess;
  int? totalFail;
  dynamic totalPurchaseAmount;
  List<Transaction>? transaction;

  EODFullReportModel(
      {status,
      reportDatetime,
      terminalNo,
      merchantName,
      merchantNo,
      totalTransaction,
      totalSuccess,
      totalFail,
      totalPurchaseAmount,
      transaction});

  EODFullReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reportDatetime = json['reportDatetime'];
    terminalNo = json['terminalNo'];
    merchantName = json['merchantName'];
    merchantNo = json['merchantNo'];
    totalTransaction = json['totalTransaction'];
    totalSuccess = json['totalSuccess'];
    totalFail = json['totalFail'];
    totalPurchaseAmount = json['totalPurchaseAmount'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['report_datetime'] = reportDatetime;
    data['terminal_no'] = terminalNo;
    data['merchant_name'] = merchantName;
    data['merchant_no'] = merchantNo;
    data['total_transaction'] = totalTransaction;
    data['total_success'] = totalSuccess;
    data['total_fail'] = totalFail;
    data['total_purchase_amount'] = totalPurchaseAmount;
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  String? transactionType;
  String? dateTime;
  String? status;
  num? amount;
  String? rrn;
  String? cardPan;

  Transaction({transactionType, dateTime, status, amount, rrn});
  Transaction.fromJson(Map<String, dynamic> json) {
    transactionType = json['transaction_type'];
    dateTime = json['created_at'];
    status = json['status'].toString();
    amount = json['amount'];
    cardPan = json['sender_name'];
    rrn = json['e_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_type'] = transactionType;
    data['date_time'] = dateTime;
    data['status'] = status;
    data['amount'] = amount.toString();
    data['rrn'] = rrn;
    data['card_pan'] = cardPan;
    return data;
  }
}
