class TerminalRequestModel {
  bool? status;
  List<TerminalData>? data;

  TerminalRequestModel({this.status, this.data});

  TerminalRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TerminalData>[];
      json['data'].forEach((v) {
        data!.add(TerminalData.fromJson(v));
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

class TerminalData {
  String? serialNo;
  String? description;
  int? transferStatus;

  TerminalData({this.serialNo, this.description, this.transferStatus});

  TerminalData.fromJson(Map<String, dynamic> json) {
    serialNo = json['serial_no'];
    description = json['description'];
    transferStatus = json['transfer_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serial_no'] = serialNo;
    data['description'] = description;
    data['transfer_status'] = transferStatus;
    return data;
  }
}
