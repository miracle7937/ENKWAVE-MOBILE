class GenericResponse {
  bool? status;
  String? message;

  GenericResponse({this.status, this.message});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString() == "true" ? true : false;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class GenericResponse2 {
  bool? success;
  String? message;

  GenericResponse2({this.success, this.message});

  GenericResponse2.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString() == "true" ? true : false;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}
