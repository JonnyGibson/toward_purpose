import 'dart:math';
import 'package:uuid/uuid.dart';
import 'dataModel.dart';

dataModel generateTestData() {
  final now = DateTime.now();
  final last14Days =
      List.generate(14, (index) => now.subtract(Duration(days: index)))
          .reversed
          .toList();
  final measurable1 = Goal(
    typeId: Uuid().v4(),
    name: "Intentionally and purposefully meditate a lot",
    //targetWeeklyHours: [0, 1, 3, 5, 7, 15][Random().nextInt(6)]
  ); // Generates a random integer between 0 and 5 inclusive to select the targetWeeklyHours value
  final measurable2 = Goal(
    typeId: Uuid().v4(),
    name: "Engage in moderate exercise",
    //  targetWeeklyHours: [0, 1, 3, 5, 7, 15][Random().nextInt(6)]
  );
  final measurable3 = Goal(
    typeId: Uuid().v4(),
    name: "Encourage deeper friend relationships",
    // targetWeeklyHours: [0, 1, 3, 5, 7, 15][Random().nextInt(6)]
  );
  final measurables = [measurable1, measurable2, measurable3];

  final days = last14Days
      .sublist(0, 9)
      .map((date) => generateDay(date, measurables))
      .toList();
  final data = dataModel(
      goalStatement: "Intentionally improving general health and well-being",
      goalTemplates: measurables,
      days: List.from(days));
  data.generateId();
  return data;
}

Day generateDay(DateTime date, List<Goal> measurables) {
  final rng = Random(date.microsecondsSinceEpoch);
  final score = rng.nextInt(5) - 2;
  final qualitativeComment = score == -2
      ? "Really bad - ragin"
      : score == -1
          ? "Not great"
          : score == 0
              ? "fair nuff"
              : score == 1
                  ? "Good"
                  : "It was beezer";
  final day = Day(
      date: date, dailyScore: score, qualitativeComment: qualitativeComment);
  final engagement = rng.nextInt(5);
  day.measurables = measurables
      .map((element) => Goal(
            typeId: element.typeId,
            uniqueId: Uuid().v4(),
            name: element.name,
            //   targetWeeklyHours: 0,
            engagement: engagement,
          ))
      .toList();
  day.generateId();
  return day;
}

List<Activity> generateActivities(Goal measurable, Random rng, DateTime date) {
  final activitiesCount = rng.nextInt(2) + 2;
  final activities = List.generate(
      activitiesCount, (index) => generateActivity(measurable, rng, date));
  return activities;
}

Activity generateActivity(Goal measurable, Random rng, DateTime date) {
  final name =
      "${measurable.typeId?.substring(0, 3)} Activity ${Uuid().v4().substring(0, 5)}";
  final hours = rng.nextInt(4) +
      1; // Generates a random integer between 1 and 4 inclusive
  final activity = Activity(
    name: name,
    measurable_id: measurable.typeId,
    hours: hours,
    date: date,
  );
  activity.generateId();
  return activity;
}
