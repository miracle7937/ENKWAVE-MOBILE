import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';

class WalletChargeModel {
  List<UserWallet>? account;
  String? transferCharge;

  WalletChargeModel({this.account, this.transferCharge});

  WalletChargeModel.fromJson(Map<String, dynamic> json) {
    if (json['account'] != null) {
      account = <UserWallet>[];
      json['account'].forEach((v) {
        account!.add(UserWallet.fromJson(v));
      });
    }
    transferCharge = json['transfer_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.account != null) {
      data['account'] = this.account!.map((v) => v.toJson()).toList();
    }
    data['transfer_charge'] = this.transferCharge;
    return data;
  }
}
