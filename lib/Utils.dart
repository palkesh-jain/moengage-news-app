import 'package:intl/intl.dart';

class Utils {
  static String formatDateAndTimeFromISO(String? dateAndTimeInISO) {
    if (dateAndTimeInISO == null) return "unknown";
    var dateTime = DateTime.parse(dateAndTimeInISO);
    var formatter = DateFormat("d MMMM y, hh:mm a");
    return formatter.format(dateTime);
  }
}
