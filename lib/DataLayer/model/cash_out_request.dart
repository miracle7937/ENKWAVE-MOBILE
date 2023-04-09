import 'package:enk_pay_project/Constant/string_values.dart';

class CashOutRequest {
  String? amount;
  String? wallet;
  String? pin;

  CashOutRequest({this.amount, this.wallet, this.pin});

  CashOutRequest.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    wallet = json['wallet'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['wallet'] = wallet;
    data['pin'] = pin;
    return data;
  }

  isValid() => isNotEmpty(wallet) && isNotEmpty(amount);
}
