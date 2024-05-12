class FormValidationResponse {
  bool? status;
  ValidateData? data;
  String? message;

  FormValidationResponse({this.status, this.data, this.message});

  FormValidationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = ValidateData.fromJson(json['data']);
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ValidateData {
  String? name;
  String? otherField;

  ValidateData({this.name, this.otherField});

  ValidateData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    otherField = json['other_field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['other_field'] = otherField;
    return data;
  }
}
