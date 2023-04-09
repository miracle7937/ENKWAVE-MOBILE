class LGAResponse {
  bool? status;
  String? message;
  List<String>? data;

  LGAResponse({status, message, data});

  LGAResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <String>[];
      json['data'].forEach((v) {
        data!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}

class LGAData {
  int? id;
  String? lga;
  int? stateId;
  String? stateCode;
  String? state;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? latitude;
  String? longitude;
  String? wikiDataId;

  LGAData(
      {id,
      lga,
      stateId,
      stateCode,
      state,
      countryId,
      countryCode,
      countryName,
      latitude,
      longitude,
      wikiDataId});

  LGAData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lga = json['lga'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    state = json['state'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    wikiDataId = json['wikiDataId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lga'] = lga;
    data['state_id'] = stateId;
    data['state_code'] = stateCode;
    data['state'] = state;
    data['country_id'] = countryId;
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['wikiDataId'] = wikiDataId;
    return data;
  }
}
