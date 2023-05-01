// ignore_for_file: unused_import
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/dailyLog.dart';
import 'dataModel.dart';
import 'dataProvider.dart';
import 'dataStorage.dart';
import 'editMeasurable.dart';
import 'styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:toward_purpose/viewGoal.dart';

class ViewGoal extends StatefulWidget {
  @override
  _ViewGoalState createState() => _ViewGoalState();
}

class _ViewGoalState extends State<ViewGoal> {
  @override
  void initState() {
    super.initState();
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

  List<SizedBox>? getActivities(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final data = dataProvider.data;
    return data.measurables?.map((element) {
      return SizedBox(
        height: 150,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditMeasurable(id: element.id ?? "")),
            );
            setState(() {});
          },
          child: Card(
            child: ListTile(
              title: Text(
                element.name ?? "Not Set",
                style: GruppoMedium(),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(FontAwesomeIcons.clock),
                      SizedBox(height: 5),
                      Text(
                          '${data.getToday(DateTime.now())?.getTotalActivityHoursPerMeasurable(element.id) ?? 0} hours today'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(FontAwesomeIcons.clock),
                      SizedBox(height: 5),
                      Text(
                          '${data.getActivityHoursLast7DaysPerMeasureable(element.id)} hours this week'),
                      Text('Target: ${element.targetWeeklyHours} hours'),
                    ],
                  ),
                ],
              ).paddingLTRB(0, 15, 0, 5),
            ).paddingLTRB(0, 5, 0, 5),
          ),
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
    final measurables = data.measurables ?? [];
    measurables.add(measurable);
    data.measurables = measurables;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurable Goals'),
        leading: IconButton(
          icon: Icon(Icons.calendar_month_sharp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyLog()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddMeasurableDialog(context);
            },
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(height: 30),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/toward.png',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width / 5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                      maxWidth: MediaQuery.of(context).size.width / 1.3,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0x80B3E1DC),
                          Color(0x806E6F8F),
                          Color(0x809AAE43),
                          Color(0x809AAE43),
                          Color(0x806E6F8F),
                        ],
                        stops: [
                          0.0,
                          0.25,
                          0.5,
                          0.75,
                          1.0,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      data.goalStatement ?? "NotSet",
                      textAlign: TextAlign.center,
                      style: GruppoMedium(),
                    ).paddingAll(5),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            flex: 8,
            child: ListView(
              children: [
                ...?getActivities(context),
              ],
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _confirmResetData();
        },
        child: Icon(FontAwesomeIcons.trash),
      ),
    );
  }
}
