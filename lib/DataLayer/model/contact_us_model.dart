class ContactUsModel {
  bool? status;
  ContactData? data;

  ContactUsModel({status, data});

  ContactUsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ContactData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datamap = new Map<String, dynamic>();
    datamap['status'] = status;
    if (data != null) {
      datamap['data'] = data!.toJson();
    }
    return datamap;
  }
}

class ContactData {
  int? id;
  String? email;
  String? phone;
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;

  ContactData({id, email, phone, whatsapp, facebook, twitter, instagram});

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['whatsapp'] = whatsapp;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    return data;
  }
}
