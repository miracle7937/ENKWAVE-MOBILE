class AccountVerificationResponse {
  bool? status;
  String? accountName, message;

  AccountVerificationResponse({this.status, this.accountName, message});

  AccountVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    accountName = json['customer_name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['account_name'] = accountName;
    data['message'] = message;
    return data;
  }
}
