import 'package:equatable/equatable.dart';

class BasePackage extends Equatable {
  String? dataAmount;
  String? dataDesc;
  String? code;
  String? serviceID;
  setValue(String amount, String desc, String code, String serviceID) {
    dataAmount = amount;
    dataDesc = desc;
    this.code = code;
    this.serviceID = serviceID;
  }

  String? get getAmount => dataAmount;
  String? get getDesc => dataDesc;
  String? get serviceCode => code;
  String? get getServiceID => serviceID;

  @override
  // TODO: implement props
  List<Object?> get props => [dataAmount, dataDesc, code, serviceID];
}
