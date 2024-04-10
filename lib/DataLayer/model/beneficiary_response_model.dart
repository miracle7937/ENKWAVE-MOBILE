import 'bank_list_response.dart';

class BeneficiaryRespModel {
  bool? status;
  List<Beneficariy>? data;

  BeneficiaryRespModel({this.status, this.data});

  BeneficiaryRespModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Beneficariy>[];
      json['data'].forEach((v) {
        data!.add(Beneficariy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
