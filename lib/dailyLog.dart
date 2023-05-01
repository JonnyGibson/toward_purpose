import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataModel.dart';
import 'dataProvider.dart';
import 'extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DailyLog extends StatefulWidget {
  const DailyLog({Key? key}) : super(key: key);

  @override
  _DailyLogState createState() => _DailyLogState();
}

class _DailyLogState extends State<DailyLog> {
  late DataProvider dataProvider;
  List<Day?> days = [];

  @override
  void initState() {
    super.initState();
    dataProvider = context.read<DataProvider>();
    days = dataProvider.data.days!;
    days.sort((a, b) {
      if (a?.date == null || b?.date == null) {
        // If either date is null, consider them equal
        return 0;
      }
      return b!.date!.compareTo(a!.date!);
    });
  }

  final Color primaryColor = Color.fromRGBO(243, 198, 152, 1.0);
  final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
  final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);

  Widget getNumbers(int num) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = -2; i <= 2; i++)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: i == num ? secondaryColor : primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Fluttertoast.showToast(
                  msg: "Not Done Yet !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text((formatDate(days[index]?.date))),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: getNumbers(days[index]?.dailyScore ?? 0),
                    ),
                  ),
                ],
              ),
              children: [
                ListTile(
                  title: Text(days[index]?.qualitativeComment ?? ""),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Activity?> getActivitiesByMeasureId(Measurable measurable) {
    final allActivities =
        dataProvider.data.days?.expand((day) => day.activities ?? []).toList();

    return allActivities
            ?.where((activity) => activity?.measurable_id == measurable.id)
            .map((activity) => activity as Activity?)
            .toList() ??
        [];
  }
}
