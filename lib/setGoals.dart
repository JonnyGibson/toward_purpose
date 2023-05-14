import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/viewGoal.dart';
import 'package:uuid/uuid.dart';

import 'dataModel.dart';
import 'dataProvider.dart';
import 'styles.dart';

class SetGoals extends StatefulWidget {
  const SetGoals({Key? key}) : super(key: key);

  @override
  _SetGoalsState createState() => _SetGoalsState();
}

class _SetGoalsState extends State<SetGoals> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "";
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _editGoal(BuildContext context, int index) {
    // var dataProvider = context.watch<DataProvider>();
    var dataProvider = Provider.of<DataProvider>(context, listen: false);

    String updatedGoalName = dataProvider.data.goalTemplates?[index].name ?? "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Goal"),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              updatedGoalName = value;
            },
            controller: TextEditingController(text: updatedGoalName),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                dataProvider.data.goalTemplates?[index].name = updatedGoalName;
                setState(() {
                  dataProvider.saveData();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    if (dataProvider.data.goalTemplates == null)
      dataProvider.data.goalTemplates = [];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              height: 150,
              child: FittedBox(
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fitWidth,
                child: Image.asset(
                  'assets/toward.png',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'How will you do it?',
                style: Gruppolarge(),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: dataProvider.data.goalTemplates?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.ads_click),
                    title: Text(
                      dataProvider.data.goalTemplates?[index].name ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editGoal(context, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              dataProvider.data.goalTemplates?.removeAt(index);
                              dataProvider.saveData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newGoal = '';
                            return AlertDialog(
                              title: Text('Add New Goal'),
                              content: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  newGoal = value;
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Add'),
                                  onPressed: () {
                                    dataProvider.data.goalTemplates?.add(
                                        new Goal(
                                            name: newGoal,
                                            typeId: Uuid().v4()));
                                    setState(() {
                                      dataProvider.saveData();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Add Goal"),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (dataProvider.data.goalTemplates != null) {
                          var day = dataProvider.data.getToday(DateTime.now());
                          dataProvider.data.days
                              ?.removeWhere((element) => element.id == day?.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewGoal()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Finish',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
