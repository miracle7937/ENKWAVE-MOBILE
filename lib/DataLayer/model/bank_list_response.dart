import 'package:equatable/equatable.dart';

class TransferProperties {
  List<Bank>? data;
  List<UserWallet>? userWallets;
  String? transferCharge;
  TransferProperties({this.data, this.userWallets, this.transferCharge});

  TransferProperties.fromJson(Map<String, dynamic> json) {
    transferCharge = json['transfer_charge'];

    if (json['banks'] != null) {
      data = <Bank>[];
      json['banks'].forEach((v) {
        data!.add(Bank.fromJson(v));
      });
    }
    if (json['account'] != null) {
      userWallets = <UserWallet>[];
      json['account'].forEach((v) {
        userWallets!.add(UserWallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data["transfer_charge"] = transferCharge;
    return data;
  }
}

class Bank {
  String? bankCbnCode;
  String? bankName;

  Bank({this.bankCbnCode, this.bankName});

  Bank.fromJson(Map<String, dynamic> json) {
    bankCbnCode = json['code'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = bankCbnCode;
    data['bankName'] = bankName;
    return data;
  }
}

class UserWallet extends Equatable {
  String? title;
  num? amount;
  String? key;

  UserWallet({this.title, this.amount, this.key});

  UserWallet.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    amount = json['amount'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['amount'] = amount;
    data['key'] = key;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, amount, key];
}
