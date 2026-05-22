class EODRequestModel {
  String? userID;
  String? date;
  String? userTerminalID;

  EODRequestModel({this.userID, this.date, this.userTerminalID});

  EODRequestModel.fromJson(Map<String, dynamic> json) {
    userID = json['user_id'];
    date = json['date'];
    userTerminalID = json['userTerminalID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userID;
    data['date'] = date;
    data['userTerminalID'] = userTerminalID;
    return data;
  }
}
