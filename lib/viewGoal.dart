// ignore_for_file: unused_import
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/dailyLog.dart';
import 'dataModel.dart';
import 'dataProvider.dart';
import 'dataStorage.dart';
import 'dialogs.dart';
import 'editMeasurable.dart';
import 'extensions.dart';
import 'pastDaysCarousel.dart';
import 'styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:toward_purpose/viewGoal.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'dart:math' as math;

class ViewGoal extends StatefulWidget {
  @override
  _ViewGoalState createState() => _ViewGoalState();
}

class _ViewGoalState extends State<ViewGoal> {
  @override
  void initState() {
    super.initState();
  }

  var displayDate = DateTime.now();
  void moveDisplayDate(int moveBy) {
    setState(() {
      displayDate = displayDate.add(Duration(days: moveBy));
    });
  }

  Future<void> _confirmResetData() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Data?"),
          content: Text(
              "Are you sure you want to delete everything and start again?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
              child: Text("Reset"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final dataProvider = context.read<DataProvider>();
      dataProvider.clearData();
      Navigator.pushNamed(context, '/main');
    }
  }

  void updateDayMeasurables(BuildContext context, Day? _day) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final data = dataProvider.data;
    int index = data.days!.indexWhere((x) => x.id == _day?.id);
    if (index != -1) {
      data.days![index] = _day!;
      dataProvider.saveData();
    }
  }

  List<Container>? getActivities(BuildContext context, Day? day) {
    final dataProvider = context.watch<DataProvider>();
    List<int> _values = [1, 2, 3, 4, 5];
    return day?.measurables?.map((element) {
      return Container(
        child: Card(
          child: ListTile(
                  title: Text(
                    element.name ?? "Not Set",
                    style: GruppoSmall(),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: List.generate(
                            _values.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    element.engagement = index + 1;

                                    dataProvider.saveData();
                                  });
                                },
                                child: Icon(
                                  Icons.star,
                                  color: element.engagement > index
                                      ? Colors.amber
                                      : Colors.grey,
                                ).paddingAll(3),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ).paddingLTRB(0, 10, 0, 0))
              .paddingLTRB(0, 5, 0, 5),
        ),
      );
    }).toList();
  }

  void addNewMeasurable(
      BuildContext context, String name, int targetWeeklyHours) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final data = dataProvider.data;
    final measurable = Measurable(
      name: name,
      targetWeeklyHours: targetWeeklyHours,
    );
    measurable.generateId();
    final measurables = data.measurableTemplates ?? [];
    measurables.add(measurable);
    data.measurableTemplates = measurables;

    setState(() {
      dataProvider.saveData();
    });
  }

  List<int> options = [0, 1, 3, 5, 7, 15];
  List<String> optionsText = [
    'None',
    '1 hour',
    '3 hours',
    '5 hours',
    '7 hours',
    '15 hours'
  ];
  void showAddMeasurableDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    int targetWeeklyHours = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter Title",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weekly Target Hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: targetWeeklyHours,
                      items: List.generate(
                        options.length,
                        (index) => DropdownMenuItem(
                          value: options[index],
                          child: Text(optionsText[index]),
                        ),
                      ),
                      onChanged: (value) {
                        targetWeeklyHours = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      icon: Icon(FontAwesomeIcons.bullseye),
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text;
                if (name.isNotEmpty)
                  addNewMeasurable(context, name, targetWeeklyHours);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final data = dataProvider.data;
    var day = data.getToday(displayDate);
    if (day == null) {
      day = data.newDay(displayDate);
      if (data.days == null) data.days = [];
      data.days?.add(day);
      dataProvider.saveData();
    }

    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Container(
                  height: 200, // Set the height of the header
                  width: double
                      .infinity, // Set the width of the header to full width
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/toward.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: GruppoMedium(),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.today),
                title: Text(
                  "View Daily Log",
                  style: GruppoMedium(),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DailyLog()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  "Settings",
                  style: GruppoMedium(),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text(
                  "Delete data",
                  style: GruppoMedium(),
                ),
                onTap: () {
                  _confirmResetData();
                },
              ),
              Container(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final packageInfo = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('App Name: ${packageInfo.appName}'),
                          Text('Package Name: ${packageInfo.packageName}'),
                          Text('Version: ${packageInfo.version}'),
                          Text('Build Number: ${packageInfo.buildNumber}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ).paddingLTRB(0, 50, 0, 0),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Daily Commitments'),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_month),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyLog()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  color: secondaryColor.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/toward.png',
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      Flexible(
                        child: Text(
                          data.goalStatement ?? "NotSet",
                          textAlign: TextAlign.center,
                          style: GruppoMedium(),
                        ).paddingAll(5),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 1, // set flex to a value greater than 0
              child: Text(
                "Rate engagement with goals",
                style: GruppoSmall().copyWith(color: redyColor),
              ).paddingLTRB(0, 10, 0, 0),
            ),
            Expanded(
              flex: 10,
              child: PastDaysCarousel(),
            ),
          ],
        ));
  }
}
