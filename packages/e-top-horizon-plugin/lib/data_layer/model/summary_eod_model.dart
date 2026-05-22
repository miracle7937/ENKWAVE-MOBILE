class SummaryEODModel {
  bool? status;
  String? merchantNo;
  String? terminalNo;
  String? merchantName;
  List<SummaryList>? summaryList;

  SummaryEODModel(
      {this.status, this.summaryList, merchantNo, terminalNo, merchantName});

  SummaryEODModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    merchantNo = json['merchant_no'];
    terminalNo = json['terminal_no'];
    merchantName = json['merchant_name'];
    if (json['summaryList'] != null) {
      summaryList = <SummaryList>[];
      json['summaryList'].forEach((v) {
        summaryList!.add(new SummaryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['terminal_no'] = this.terminalNo;
    data['merchant_no'] = this.merchantNo;
    data['merchant_name'] = this.merchantName;
    if (this.summaryList != null) {
      data['summaryList'] = this.summaryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SummaryList {
  String? type;
  int? times;

  SummaryList({this.type, this.times});

  SummaryList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    times = json['times'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['times'] = this.times;
    return data;
  }
}
