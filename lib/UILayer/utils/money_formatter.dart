import 'package:intl/intl.dart';

amountFormatter(String? number) {
  if (number != null) {
    final oCcy = NumberFormat("#,###", "en_US");
    return "NGN${oCcy.format(double.parse(number))}";
  } else {
    return "NA";
  }
}
