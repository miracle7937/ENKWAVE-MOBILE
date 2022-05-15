class InAppUserResponseModel {
  bool? success;
  List<Data>? data;
  String? message;

  InAppUserResponseModel({this.success, this.data, this.message});

  InAppUserResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? middleName;
  String? firstName;
  String? lastName;

  Data({this.middleName, this.firstName, this.lastName});

  Data.fromJson(Map<String, dynamic> json) {
    middleName = json['middle_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['middle_name'] = this.middleName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
