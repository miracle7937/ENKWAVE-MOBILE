import 'bank_list_response.dart';

class ApiServiceProperty {
  List<UserWallet>? account;
  List<Service>? service;

  ApiServiceProperty({this.account, this.service});

  ApiServiceProperty.fromJson(Map<String, dynamic> json) {
    if (json['account'] != null) {
      account = <UserWallet>[];
      json['account'].forEach((v) {
        account!.add(UserWallet.fromJson(v));
      });
    }
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (account != null) {
      data['account'] = account!.map((v) => v.toJson()).toList();
    }
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? id;
  String? serviceName;
  String? url;

  Service({this.id, this.serviceName, this.url});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['url'] = url;
    return data;
  }
}
