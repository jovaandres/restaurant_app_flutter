import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    final timeSpesific = "11:00:00";
    final completeFormat = DateFormat('y/M/d H:m:s');

    final todayDate = dateFormat.format(now);
    final todayDateAndTime = "$todayDate $timeSpesific";
    var resultToday = completeFormat.parseStrict(todayDateAndTime);

    var formatted = resultToday.add(Duration(days: 1));
    final tommorowDate = dateFormat.format(formatted);
    final tommorowDateAndTime = '$tommorowDate $timeSpesific';
    var resultTomorrow = completeFormat.parseStrict(tommorowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
