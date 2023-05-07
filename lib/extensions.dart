import 'package:intl/intl.dart';

import 'dataModel.dart';

// extension AddActivityToDay on dataModel {
//   Day? addActivityToDay(DateTime date, Activity activity) {
//     final matchingDay = this.days?.firstWhere((day) =>
//         day.date?.year == date.year &&
//         day.date?.month == date.month &&
//         day.date?.day == date.day);
//     matchingDay?.activities?.add(activity);
//     return matchingDay;
//   }
// }

extension DoesDayExist on List<Day> {
  bool doesDayExist(DateTime date) {
    return this.any(
      (day) =>
          day.date?.year == date.year &&
          day.date?.month == date.month &&
          day.date?.day == date.day,
    );
  }
}

// dataModel addActivityToday(DateTime date, dataModel data, Activity activity) {
//   final matchingDay = data.days?.firstWhere((day) =>
//       day.date?.year == date.year &&
//       day.date?.month == date.month &&
//       day.date?.day == date.day);

//   if (matchingDay != null) {
//     if (matchingDay.activities == null) matchingDay.activities = [];
//     matchingDay.activities?.add(activity);
//     return data;
//   } else {
//     final newDay = Day(date: date);
//     if (data.days == null) data.days = [];
//     data.days?.add(newDay);
//     if (newDay.activities == null) newDay.activities = [];
//     newDay.activities?.add(activity);
//     return data;
//   }
// }

String formatDate(DateTime? date, {String? format = 'EEE dd MMM yyyy'}) {
  if (date == null) {
    return '';
  } else {
    return DateFormat(format ?? 'EEE dd MMM yyyy').format(date);
  }
}
