import 'package:intl/intl.dart';

amountFormatter(String? number) {
  if (number == "null") {
    return "NA";
  }
  if (number != null) {
    final oCcy = NumberFormat.currency(locale: 'en_US', symbol: '');
    return "NGN${oCcy.format(double.parse(number))}";
  } else {
    return "NA";
  }
}

amountFormatterWithoutDecimal(String? number) {
  if (number == "null") {
    return "NA";
  }
  if (number != null) {
    final oCcy =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 0);
    int amount = double.parse(number).toInt();
    return "NGN${oCcy.format(amount)}";
  } else {
    return "NA";
  }
}
