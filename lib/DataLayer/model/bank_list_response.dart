class ListOfBanks {
  List<Bank>? data;

  ListOfBanks({this.data});

  ListOfBanks.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Bank>[];
      json['data'].forEach((v) {
        data!.add(Bank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bank {
  String? bankCbnCode;
  String? bankNipCode;
  String? bankName;

  Bank({this.bankCbnCode, this.bankNipCode, this.bankName});

  Bank.fromJson(Map<String, dynamic> json) {
    bankCbnCode = json['bank_cbn_code'];
    bankNipCode = json['bank_nip_code'];
    bankName = json['bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_cbn_code'] = bankCbnCode;
    data['bank_nip_code'] = bankNipCode;
    data['bank_name'] = bankName;
    return data;
  }
}
