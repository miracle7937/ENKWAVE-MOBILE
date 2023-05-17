import 'history_model.dart';

class TerminalTransactionsModel {
  bool? status;
  num? totalTransactions;
  num? dailyTransactions;
  List<TransactionData>? history;

  TerminalTransactionsModel(
      {this.status,
      this.totalTransactions,
      this.dailyTransactions,
      this.history});

  TerminalTransactionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalTransactions = json['total_transactions'];
    dailyTransactions = json['daily_transactions'];
    if (json['history'] != null) {
      history = <TransactionData>[];
      json['history'].forEach((v) {
        history!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['total_transactions'] = totalTransactions;
    data['daily_transactions'] = dailyTransactions;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
