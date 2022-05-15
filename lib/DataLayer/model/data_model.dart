class DataModel {
  String? phone;
  String? amount;
  String? dataplan;
  String? productType;

  DataModel({this.phone, this.amount, this.dataplan, this.productType});

  DataModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    amount = json['amount'];
    dataplan = json['dataplan'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['amount'] = this.amount;
    data['dataplan'] = this.dataplan;
    data['product_type'] = this.productType;
    return data;
  }
}
