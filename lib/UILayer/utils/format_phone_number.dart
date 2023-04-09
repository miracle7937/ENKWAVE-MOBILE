import 'package:intl/intl.dart';

class PhoneNumber {
  static String format(String number) {
    var phone = number.replaceAll(" ", "");
    if (phone.contains("+234")) {
      return phone;
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
