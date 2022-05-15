class FeaturePermissionModel {
  bool? status;
  List<PermissionModelData>? data;

  FeaturePermissionModel({this.status, this.data});

  FeaturePermissionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PermissionModelData>[];
      json['data'].forEach((v) {
        data!.add(PermissionModelData.fromJson(v));
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

class PermissionModelData {
  int? id;
  bool? pos;
  bool? transfer;
  bool? payBills;
  bool? data;
  bool? buyAirtime;
  bool? insurance;
  bool? examCard;
  bool? buyTicket;
  bool? exchange;
  bool? flight;

  PermissionModelData(
      {this.id,
      this.pos,
      this.transfer,
      this.payBills,
      this.data,
      this.buyAirtime,
      this.insurance,
      this.examCard,
      this.buyTicket,
      this.exchange});

  PermissionModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pos = json['pos'];
    transfer = json['transfer'];
    payBills = json['payBills'];
    data = json['buyData'];
    buyAirtime = json['buyAirtime'];
    insurance = json['insurance'];
    examCard = json['examCard'];
    buyTicket = json['buyTicket'];
    exchange = json['exchange'];
    flight = json['flight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pos'] = pos;
    data['transfer'] = transfer;
    data['payBills'] = payBills;
    data['buyData'] = data;
    data['buyAirtime'] = buyAirtime;
    data['insurance'] = insurance;
    data['examCard'] = examCard;
    data['buyTicket'] = buyTicket;
    data['exchange'] = exchange;
    data['flight'] = flight;
    return data;
  }
}
