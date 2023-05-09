import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataModel.dart';
import 'dataProvider.dart';
import 'extensions.dart';

class DailyLog extends StatefulWidget {
  const DailyLog({Key? key}) : super(key: key);

  @override
  _DailyLogState createState() => _DailyLogState();
}

class _DailyLogState extends State<DailyLog> {
  late DataProvider dataProvider;
  //var weeks = [];

  @override
  void initState() {
    super.initState();
  }

  final Color? primaryColor = Colors.amber[50];
  final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
  final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);
  List<List<Day>> weeks = [];
  List<List<Day>> addDaysToWeeks(List<Day> days) {
    List<List<Day>> weeks = [];

    days.sort((a, b) => a.date.compareTo(b.date));

    DateTime monday =
        days[0].date.subtract(Duration(days: days[0].date.weekday - 1));
    DateTime sunday = monday.add(Duration(days: 6));

    List<Day> currentWeek = [];

    for (int i = 0; i < days.length; i++) {
      Day day = days[i];

      if (day.date.isBefore(monday)) {
        continue;
      }

      if (day.date.isAfter(sunday)) {
        weeks.add(currentWeek);
        currentWeek = [];

        monday = monday.add(Duration(days: 7));
        sunday = sunday.add(Duration(days: 7));
      }

      currentWeek.add(day);
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return weeks;
  }

  DateTime getMonday(DateTime date) {
    if (date.weekday == DateTime.monday) {
      return date;
    }

    // Calculate the number of days to subtract to get to the previous Monday
    int daysToMonday = date.weekday - DateTime.monday;
    if (daysToMonday < 0) {
      daysToMonday += 7;
    }

    // Subtract the number of days to get to the previous Monday
    return date.subtract(Duration(days: daysToMonday));
  }

  int getMedianDailyScore(List<Day> days) {
    days.sort((a, b) => a.dailyScore!.compareTo(b.dailyScore ?? 0));

    // Calculate the length of the list
    int length = days.length;

    // Calculate the median daily score
    int medianDailyScore;
    if (length % 2 == 0) {
      int middleIndex = length ~/ 2;
      medianDailyScore =
          (days[middleIndex - 1].dailyScore! + days[middleIndex].dailyScore!) ~/
              2;
    } else {
      int middleIndex = length ~/ 2;
      medianDailyScore = days[middleIndex].dailyScore!;
    }
    return medianDailyScore;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final data = dataProvider.data;
    weeks = addDaysToWeeks(data.days ?? []).reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: weeks.length,
        itemBuilder: (BuildContext context, int index) {
          var week = weeks[index];
          int totalEngagement = week.fold(0, (acc, day) {
            return acc +
                day.measurables!.fold(0, (acc2, measurable) {
                  return acc2 + measurable.engagement;
                });
          });
          int totalPossibleEngagementCount =
              (week[0].measurables!.length * 7) * 5;
          double engagementPercentage =
              (totalEngagement / totalPossibleEngagementCount) * 100;
          var medianDailyScore = getMedianDailyScore(week);
          List<int> _scorevalues = [-2, -1, 0, 1, 2];
          return ListTile(
            title: Text(
                'Week of ${formatDate(getMonday(week[0].date), format: "dd MMM yyyy")} '),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: engagementPercentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          engagementPercentage == 0
                              ? 'No Engagement with goals'
                              : 'Engagement with goals',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).paddingLTRB(10, 0, 0, 0),
                    ],
                  ),
                ).paddingAll(10),
                Row(
                  children: [
                    Text("Average Daily Score:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _scorevalues.map((value) {
                        return Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                            color: medianDailyScore == value
                                ? secondaryColor
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              value.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ).paddingAll(3);
                      }).toList(),
                    ),
                  ],
                ).paddingLTRB(10, 5, 0, 10)
              ],
            ),
          );
        },
      ).paddingLTRB(0, 20, 0, 0),
    );
  }
}
