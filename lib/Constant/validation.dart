import 'package:enk_pay_project/Constant/string_values.dart';

class ValidationController {
  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidPhoneNumber(String? phone) {
    if (isEmpty((phone))) {
      return false;
    }
    RegExp regExp = RegExp(r'^(?:\+234|0)(?:80|81|70|90|91|811)\d{8}$');
    return regExp.hasMatch(phone!);
  }
}
