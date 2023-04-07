import 'package:equatable/equatable.dart';

import '../bank_list_response.dart';

class ElectricCompanyResponse {
  bool? status;
  List<ElectricCompanyData>? data;
  List<UserWallet>? userWallets;

  ElectricCompanyResponse({status, data, userWallets});

  ElectricCompanyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ElectricCompanyData>[];
      json['data'].forEach((v) {
        data!.add(ElectricCompanyData.fromJson(v));
      });
    }

    if (json['account'] != null) {
      userWallets = <UserWallet>[];
      json['account'].forEach((v) {
        userWallets?.add(UserWallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data1 = <String, dynamic>{};
    data1['status'] = status;
    if (data != null) {
      data1['data'] = data!.map((v) => v.toJson()).toList();
    }
    data1['account'] = userWallets!.map((v) => v.toJson()).toList();
    return data1;
  }
}

class ElectricCompanyData extends Equatable {
  String? name;
  String? code;

  ElectricCompanyData({name, code});

  ElectricCompanyData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, code];
}
