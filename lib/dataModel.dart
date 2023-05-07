import 'package:uuid/uuid.dart';
import 'extensions.dart';

class dataModel {
  String? id;
  String? goalStatement;
  List<Measurable>? measurableTemplates;
  List<Day>? days;

  dataModel({
    this.id,
    this.goalStatement,
    this.measurableTemplates,
    this.days,
  });

  factory dataModel.fromJson(Map<String, dynamic> json) => dataModel(
        id: json['id'] as String?,
        goalStatement: json['goalStatement'] as String?,
        measurableTemplates: (json['measurables'] as List<dynamic>?)
            ?.map((e) => Measurable.fromJson(e as Map<String, dynamic>))
            .toList(),
        days: (json['days'] as List<dynamic>?)
            ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'goalStatement': goalStatement,
        'measurables': measurableTemplates?.map((e) => e.toJson()).toList(),
        'days': days?.map((e) => e.toJson()).toList(),
      };

  void generateId() {
    id = const Uuid().v4();
  }

  Day? getToday(DateTime date, {bool matchTime = false}) {
    if (days == null) {
      return null;
    }
    var dayExists = days!.any((day) => matchTime
        ? day.date == date
        : day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day);
    if (dayExists)
      return days!.firstWhere((day) => matchTime
          ? day.date == date
          : day.date.year == date.year &&
              day.date.month == date.month &&
              day.date.day == date.day);

    return null;
  }

  List<Day?> getDays(List<DateTime> dates, {bool matchTime = false}) {
    return dates.map((date) => getToday(date, matchTime: matchTime)).toList();
  }

  List<DateTime> getLast7Days() {
    List<DateTime> last7Days = [];
    for (int i = 0; i < 7; i++) {
      last7Days.add(DateTime.now().subtract(Duration(days: i)));
    }
    return last7Days;
  }

  Day newDay(DateTime date) {
    Day day = Day(date: date);
    day.generateId();

    day.dailyScore = 0;
    day.measurables = this
        .measurableTemplates
        ?.map((element) => Measurable(
              typeId: element.typeId,
              uniqueId: Uuid().v4(),
              name: element.name,
              targetWeeklyHours: 0,
              engagement: 0,
            ))
        .toList();
    return day;
  }
}

class Measurable {
  String? uniqueId;
  String? typeId;
  String? name;
  int targetWeeklyHours;
  int engagement;

  Measurable(
      {this.typeId,
      this.uniqueId,
      this.name,
      this.targetWeeklyHours = 0,
      this.engagement = 0});

  factory Measurable.fromJson(Map<String, dynamic> json) => Measurable(
        uniqueId: json['uniqueId'] as String?,
        typeId: json['id'] as String?,
        name: json['name'] as String?,
        targetWeeklyHours: json['targetWeeklyHours'] as int,
        engagement: json['engagement'] as int,
      );

  Map<String, dynamic> toJson() => {
        'uniqueId': uniqueId,
        'typeId': typeId,
        'name': name,
        'targetWeeklyHours': targetWeeklyHours,
        'engagement': engagement,
      };

  void generateId() {
    typeId = const Uuid().v4();
  }

  void generateUniqueId() {
    uniqueId = const Uuid().v4();
  }
}

class Day {
  String? id;
  DateTime date;
  int? dailyScore;
  String? qualitativeComment;
  List<Measurable>? measurables;

  Day({
    this.id,
    required this.date,
    this.dailyScore,
    this.qualitativeComment,
    this.measurables,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json['id'] as String?,
        date: DateTime.parse(json['date'] as String),
        dailyScore: json['dailyScore'] as int?,
        qualitativeComment: json['qualitativeComment'] as String?,
        measurables: (json['measurables'] as List<dynamic>?)
            ?.map((e) => Measurable.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'dailyScore': dailyScore,
        'qualitativeComment': qualitativeComment,
        'measurables': measurables?.map((a) => a.toJson()).toList(),
      };

  void generateId() {
    id = const Uuid().v4();
  }

  // int getTotalActivityHoursPerMeasurable(String? measurableId) {
  //   int totalHours = 0;
  //   if (activities != null) {
  //     for (Activity activity in activities!) {
  //       if ((activity.hours != null) &&
  //           (activity.measurable_id == measurableId)) {
  //         totalHours += activity.hours!;
  //       }
  //     }
  //   }
  //   return totalHours;
  // }
}

class Activity {
  String? id;
  String? name;
  String? measurable_id;
  int? hours;
  DateTime date;
  String formatedDate;

  Activity({
    this.id,
    this.name,
    this.measurable_id,
    this.hours,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        formatedDate = formatDate(date);

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String?,
        name: json['name'] as String?,
        measurable_id: json['measurable_id'] as String?,
        hours: (json['hours'] as num?)?.toInt(),
        date: DateTime.tryParse(json['date'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'measurable_id': measurable_id,
        'hours': hours,
        'date': date.toIso8601String(),
      };

  static Activity fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] ?? Uuid().v4(),
      name: map['name'],
      measurable_id: map['measurable_id'],
      hours: map['hours'],
      date: DateTime.tryParse(map['date'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? Uuid().v4(),
      'name': name,
      'measurable_id': measurable_id,
      'hours': hours,
      'date': date.toIso8601String(),
    };
  }

  void generateId() {
    id = const Uuid().v4();
    formatedDate = formatDate(date);
  }
}
