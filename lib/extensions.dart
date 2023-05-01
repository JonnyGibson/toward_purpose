import 'package:intl/intl.dart';

import 'dataModel.dart';

extension FindOrCreateDay on dataModel {
  Day findOrCreateDay(DateTime date) {
    final matchingDay = this.days?.firstWhere(
          (day) =>
              day.date?.year == date.year &&
              day.date?.month == date.month &&
              day.date?.day == date.day,
          orElse: () => Day(date: date),
        );
    if (matchingDay != null) {
      return matchingDay;
    } else {
      final newDay = Day(date: date);
      if (this.days == null) this.days = [];
      this.days?.add(newDay);
      return newDay;
    }
  }
}

String formatDate(DateTime? date) {
  if (date == null) {
    return '';
  } else {
    return DateFormat('EEE dd MMM yyyy').format(date);
  }
}
