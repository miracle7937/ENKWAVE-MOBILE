import 'package:enk_pay_project/Constant/string_values.dart';

class BillPaymentModel {
  String? billerId;
  String? customerId;
  String? serviceId;
  String? customerPhone;
  String? customerName;
  String? otherField;
  String? amount;
  String? debitAccount;

  BillPaymentModel(
      {this.billerId,
      this.customerId,
      this.serviceId,
      this.customerPhone,
      this.customerName,
      this.otherField,
      this.amount,
      this.debitAccount});

  BillPaymentModel.fromJson(Map<String, dynamic> json) {
    billerId = json['billerId'];
    customerId = json['customerId'];
    serviceId = json['serviceId'];
    customerPhone = json['customerPhone'];
    customerName = json['customerName'];
    otherField = json['otherField'];
    amount = json['amount'];
    debitAccount = json['debitAccount'];
  }
  final Map<String, dynamic> fieldsValue = <String, dynamic>{};
  Map<String, dynamic> toJson() {
    fieldsValue['billerId'] = billerId;
    fieldsValue['serviceId'] = serviceId;
    return fieldsValue;
  }

  bool _hasNullValue(Map map) {
    for (var value in map.values) {
      if (isEmpty(value)) {
        return true;
      }
    }
    return false;
  }

  bool get validForm => !_hasNullValue(toJson());
}
