class ServiceLookUResponse {
  bool? status;
  String? user;
  String? message;

  ServiceLookUResponse({this.status, this.user, this.message});

  ServiceLookUResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['name'] = user;
    data['message'] = message;
    return data;
  }
}
