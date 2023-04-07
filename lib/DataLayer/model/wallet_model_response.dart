import 'bank_list_response.dart';

class UserWalletResponse {
  bool? status;
  String? message;

  List<UserWallet>? userWallets;

  UserWalletResponse({this.status, this.userWallets});

  UserWalletResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString() == "true" ? true : false;
    message = json['message'];
    if (json['account'] != null) {
      userWallets = <UserWallet>[];
      json['account'].forEach((v) {
        userWallets!.add(UserWallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['account'] = userWallets;
    data['message'] = message;
    return data;
  }
}
