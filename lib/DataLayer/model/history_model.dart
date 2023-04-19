class HistoryModel {
  bool? status;
  List<TransactionData>? transactionData;

  HistoryModel({status, transactionData});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      transactionData = <TransactionData>[];
      json['data'].forEach((v) {
        transactionData!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (transactionData != null) {
      data['data'] = transactionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  num? id;
  num? userId;
  String? refTransId;
  String? eRef;
  String? transactionType;
  String? type;
  num? debit;
  num? credit;
  num? amount;
  num? balance;
  num? fee;
  num? fromUserId;
  String? terminalId;
  String? toUserId;
  String? createdAt;
  String? updatedAt;
  String? note;
  String? transactionId;
  num? status;
  String? serialNo;
  num? eCharges;
  String? trxDate;
  String? trxTime;
  String? senderName;
  String? senderBank;
  String? senderAccountNo;
  String? receiverName;
  String? reveiverAccountNo;
  String? title;

  TransactionData(
      {id,
      userId,
      refTransId,
      eRef,
      transactionType,
      type,
      debit,
      credit,
      amount,
      balance,
      fee,
      fromUserId,
      terminalId,
      toUserId,
      createdAt,
      updatedAt,
      note,
      transactionId,
      status,
      serialNo,
      eCharges,
      trxDate,
      trxTime,
      senderName,
      senderBank,
      senderAccountNo,
      receiverName,
      reveiverAccountNo,
      title});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    refTransId = json['ref_trans_id'];
    eRef = json['e_ref'];
    transactionType = json['transaction_type'];
    type = json['type'];
    debit = json['debit'];
    credit = json['credit'];
    amount = json['amount'];
    balance = json['balance'];
    fee = json['fee'];
    fromUserId = json['from_user_id'];
    terminalId = json['terminal_id'];
    toUserId = json['to_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    note = json['note'];
    transactionId = json['transaction_id'];
    status = json['status'];
    serialNo = json['serial_no'];
    eCharges = json['e_charges'];
    trxDate = json['trx_date'];
    trxTime = json['trx_time'];
    senderName = json['sender_name'];
    senderBank = json['sender_bank'];
    senderAccountNo = json['sender_account_no'];
    receiverName = json['receiver_name'];
    reveiverAccountNo = json['reveiver_account_no'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['ref_trans_id'] = refTransId;
    data['e_ref'] = eRef;
    data['transaction_type'] = transactionType;
    data['type'] = type;
    data['debit'] = debit;
    data['credit'] = credit;
    data['amount'] = amount;
    data['balance'] = balance;
    data['fee'] = fee;
    data['from_user_id'] = fromUserId;
    data['terminal_id'] = terminalId;
    data['to_user_id'] = toUserId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['note'] = note;
    data['transaction_id'] = transactionId;
    data['status'] = status;
    data['serial_no'] = serialNo;
    data['e_charges'] = eCharges;
    data['trx_date'] = trxDate;
    data['trx_time'] = trxTime;
    data['sender_name'] = senderName;
    data['sender_bank'] = senderBank;
    data['sender_account_no'] = senderAccountNo;
    data['receiver_name'] = receiverName;
    data['reveiver_account_no'] = reveiverAccountNo;
    data['title'] = title;
    return data;
  }
}
