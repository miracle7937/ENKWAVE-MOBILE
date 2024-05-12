class DataRequestModel {
  String? phoneNumber;
  String? amount;
  String? network;
  String? productId;

  DataRequestModel(
      {this.phoneNumber, this.amount, this.network, this.productId});

  DataRequestModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    amount = json['amount'];
    network = json['network'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['amount'] = amount;
    data['network'] = network;
    data['product_id'] = productId;
    return data;
  }
}
