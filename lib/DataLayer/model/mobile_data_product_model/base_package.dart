class BasePackage {
  late String? dataAmount;
  String? dataDesc;
  setValue(String amount, String desc) {
    dataAmount = amount;
    dataDesc = desc;
  }

  String? get getAmount => dataAmount;
  String? get getDesc => dataDesc;
}
