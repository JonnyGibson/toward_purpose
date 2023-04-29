import 'package:hive/hive.dart';
part 'dataModel.g.dart';

@HiveType(typeId: 0)
class dataModel {
  @HiveField(0)
  String? goalStatement;

  @HiveField(1)
  List<Measurable?>? measurables;

  @HiveField(2)
  List<Day?>? days;

  dataModel({
    this.goalStatement,
    this.measurables,
    this.days,
  });
}

@HiveType(typeId: 1)
class Measurable {
  @HiveField(0)
  String? name;

  @HiveField(1)
  int? targetWeeklyHours;

  Measurable({
    this.name,
    this.targetWeeklyHours,
  });

  factory Measurable.fromJson(Map<String, dynamic> json) => Measurable(
        name: json['name'] as String?,
        targetWeeklyHours: json['targetWeeklyHours'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'targetWeeklyHours': targetWeeklyHours,
      };
}

@HiveType(typeId: 2)
class Day {
  @HiveField(0)
  String? date;

  @HiveField(1)
  int? dailyScore;

  @HiveField(2)
  String? qualitativeComment;

  @HiveField(3)
  List<Activity>? activities;

  Day({
    this.date,
    this.dailyScore,
    this.qualitativeComment,
    this.activities,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        date: json['date'] as String?,
        dailyScore: json['dailyScore'] as int?,
        qualitativeComment: json['qualitativeComment'] as String?,
        activities: (json['activities'] as List<dynamic>?)
            ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'dailyScore': dailyScore,
        'qualitativeComment': qualitativeComment,
        'activities': activities?.map((e) => e.toJson()).toList(),
      };
}

@HiveType(typeId: 3)
class Activity {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? goal;

  @HiveField(2)
  double? hours;

  Activity({
    this.name,
    this.goal,
    this.hours,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json['name'] as String?,
        goal: json['goal'] as String?,
        hours: (json['hours'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'goal': goal,
        'hours': hours,
      };
}
