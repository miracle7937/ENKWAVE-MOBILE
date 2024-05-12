class BillFormResponse {
  bool? status;
  List<FormData>? data;

  BillFormResponse({this.status, this.data});

  BillFormResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FormData>[];
      json['data'].forEach((v) {
        data!.add(FormData.fromJson(v));
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

class FormData {
  String? fieldName;
  String? fieldDescription;
  String? validation;
  String? isSelectData;
  List<Items>? items;

  FormData(
      {this.fieldName,
      this.fieldDescription,
      this.validation,
      this.isSelectData,
      this.items});

  FormData.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    fieldDescription = json['fieldDescription'];
    validation = json['validation'];
    isSelectData = json['isSelectData'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldName'] = fieldName;
    data['fieldDescription'] = fieldDescription;
    data['validation'] = validation;
    data['isSelectData'] = isSelectData;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? itemId;
  String? itemName;
  String? amount;

  Items({this.itemId, this.itemName, this.amount});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemName = json['itemName'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['itemName'] = itemName;
    data['amount'] = amount;
    return data;
  }
}
