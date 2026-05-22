class GenericResponse {
  bool? status;
  String? message;
  String? refTransId;
  String? eRef;

  GenericResponse({this.status, this.message, this.refTransId, this.eRef});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString() == "true" ? true : false;
    message = json['message'];
    refTransId = _readString(json, 'ref_trans_id') ??
        _readString(json['data'], 'ref_trans_id');
    eRef = _readString(json, 'e_ref') ?? _readString(json['data'], 'e_ref');
  }

  static String? _readString(dynamic json, String key) {
    if (json is! Map) return null;
    final v = json[key];
    if (v == null) return null;
    return v.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['ref_trans_id'] = refTransId;
    data['e_ref'] = eRef;
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
