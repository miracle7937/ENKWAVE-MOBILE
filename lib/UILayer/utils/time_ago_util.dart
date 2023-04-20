import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeUtilAgo {
  static String parse(String time) {
    DateTime dateTime = DateTime.parse(time);
    String timeAgo = timeago.format(dateTime, locale: 'en');
    return timeAgo;
  }

  static String format(time) {
    var now = DateTime.parse(time);
    var formatter = DateFormat('MMM, d h:mm a');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String format2(time) {
    var now = DateTime.parse(time);
    var formatter = DateFormat('MMM y, d h:mm a');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
}
