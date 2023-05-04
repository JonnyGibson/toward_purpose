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
        height: 140,
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
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Measurable Goals'),
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
        SizedBox(
          width: double.infinity,
          child: Container(
              color: secondaryColor.withOpacity(0.3),
              child: Column(
                children: [
                  Row(
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
                      ).paddingAll(5))
                    ],
                  )
                ],
              ).paddingLTRB(0, 20, 0, 20)),
        ),
        // SizedBox(height: 30),
        Expanded(
          // flex: 3,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showAddDayDialog(context);
                    },
                    icon: Icon(Icons.calendar_month),
                    label: Text("Daily check in"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: redyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(color: secondaryColor, width: 2),
                    ),
                  )).paddingLTRB(0, 10, 15, 0),
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
    );
  }
}
