import 'package:intl/intl.dart';

import '../../Constant/string_values.dart';

class PhoneNumber {
  static String format(String number) {
    var phone = number.replaceAll(" ", "");
    if (phone.contains("+234")) {
      return phone;
    }
    if (isNotEmpty(phone) && phone.length > 4) {
      if (phone.substring(0, 3).contains("234") && phone.length > 11) {
        return "+$phone";
      }
    }

    if (phone.length > 10) {
      String formattedNumber = phone.substring(1);
      String formattedPhoneNumber = formattedNumber = '+234$formattedNumber';
      NumberFormat('+#,###,###,###').format(int.parse(formattedNumber));
      return formattedPhoneNumber;
    }
    return phone;
  }
}
