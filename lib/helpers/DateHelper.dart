import 'package:intl/intl.dart';

class DateHelper {
  static DateFormat dateFormatter = DateFormat("dd/MM/yyyy");

  static String format(DateTime date) {
    return DateHelper.dateFormatter.format(date);
  }

  static DateTime parse(String date) {
    return dateFormatter.parse(date);
  }

  static int yearsOld(DateTime birthday) {
    return DateTime.now().difference(birthday).inDays ~/ 365;
  }
}
