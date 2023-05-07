import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/styles.dart';
import 'dataModel.dart';
import 'dataProvider.dart';

class EditMeasurable extends StatefulWidget {
  final String id;

  EditMeasurable({required this.id});

  @override
  _EditMeasurableState createState() => _EditMeasurableState();
}

class _EditMeasurableState extends State<EditMeasurable> {
  late DataProvider dataProvider;
  late Measurable measurable;
  late TextEditingController _measureableNameController;
  late int? originalTarget;

  @override
  void initState() {
    super.initState();
    dataProvider = context.read<DataProvider>();
    var measurables = [];
    //dataProvider.data.measurables!;

    measurable = measurables.firstWhere((m) => m.typeId == widget.id);
    _measureableNameController =
        TextEditingController(text: measurable.name ?? '');
    originalTarget = measurable.targetWeeklyHours;
  }

  void addNewActivity(BuildContext context, String name, int _hours) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final data = dataProvider.data;

    final activity =
        Activity(name: name, hours: _hours, measurable_id: measurable.typeId);
    activity.generateId();

    // if (data.days?.doesDayExist(DateTime.now()) ?? false) {
    //   data.addActivityToDay(DateTime.now(), activity);
    // } else {
    //   var newDay = Day(date: DateTime.now());
    //   if (data.days == null) data.days = [];
    //   data.days?.add(newDay);
    //   newDay.activities = [];
    //   newDay.activities?.add(activity);
    // };

    setState(() {
      dataProvider.saveData();
    });
  }

  void editMeasurable(BuildContext context, String measurableId, String name,
      int targetWeeklyHours) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final data = dataProvider.data;
    var mes; // = data.measurables ?.firstWhere((element) => element.typeId == measurableId);
    mes?.name = name;
    mes?.targetWeeklyHours = targetWeeklyHours;

    setState(() {
      dataProvider.saveData();
    });
  }

  // List<Activity?>? getActivitiesByMeasureId() {
  //   final allActivities =
  //       dataProvider.data.days?.expand((day) => day.activities ?? []).toList();

  //   return allActivities
  //       ?.where((activity) => activity?.measurable_id == measurable.id)
  //       .map((activity) => activity as Activity?)
  //       .toList()
  //     ?..sort((a, b) => b!.date.compareTo(a!.date));
  // }

  List<int> options = [1, 2, 3, 4, 5, 6, 7];
  List<String> optionsText = [
    '1 hour',
    '2 hours',
    '3 hours',
    '4 hours',
    '5 hours',
    '6 hours',
    '7 hours'
  ];

  List<int> mesOptions = [0, 1, 3, 5, 7, 15];
  List<String> mesOptionsText = [
    'None',
    '1 hour',
    '3 hours',
    '5 hours',
    '7 hours',
    '15 hours'
  ];

  void showEditMeasurableDialog(BuildContext context) {
    // TextEditingController nameController = TextEditingController();
    // int targetWeeklyHours = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Goal Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _measureableNameController,
                decoration: InputDecoration(
                  hintText: "Edit Title",
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
                      value: originalTarget,
                      items: List.generate(
                        mesOptions.length,
                        (index) => DropdownMenuItem(
                          value: mesOptions[index],
                          child: Text(mesOptionsText[index]),
                        ),
                      ),
                      onChanged: (value) {
                        originalTarget = value!;
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
                String name = _measureableNameController.text;
                if (name.isNotEmpty)
                  editMeasurable(context, measurable.typeId.toString(), name,
                      originalTarget!);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showAddActivityDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    int hours = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log New Activity"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "What was it?",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How long for?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: hours,
                      items: List.generate(
                        options.length,
                        (index) => DropdownMenuItem(
                          value: options[index],
                          child: Text(optionsText[index]),
                        ),
                      ),
                      onChanged: (value) {
                        hours = value!;
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
                if (name.isNotEmpty) addNewActivity(context, name, hours);
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
    // List<int> options = [0, 1, 3, 5, 7, 15];
    // List<String> optionsText = [
    //   'None',
    //   '1 hour',
    //   '3 hours',
    //   '5 hours',
    //   '7 hours',
    //   '15 hours'
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
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
                showAddActivityDialog(context);
              }),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
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
        ),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  showEditMeasurableDialog(context);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                      color: secondaryColor.withOpacity(0.3),
                      child: Column(
                        children: [
                          Text(
                            "Goal:",
                            style: GruppoMedium(),
                          ),
                          Text(measurable.name ?? "Not Set"),
                        ],
                      ).paddingLTRB(0, 20, 0, 20)),
                )),
            // Expanded(
            //     child: ListView(
            //   children: <Widget>[
            //     ...?getActivitiesByMeasureId()?.map((e) {
            //       return ListTile(
            //         title: Text(e?.name ?? ""),
            //         subtitle: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 '${e?.formatedDate}',
            //                 textAlign: TextAlign.left,
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${e?.hours} Hours',
            //                 textAlign: TextAlign.right,
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     }).toList(),
            //   ],
            // ))
          ],
        ),
      ),
    );
  }
}
