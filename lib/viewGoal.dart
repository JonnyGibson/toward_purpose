import 'package:flutter/material.dart';
import 'dataModel.dart';
import 'hiveManager.dart';

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
      // Set dataModel in Hive to null
      await HiveManager.dataBox.put('data', new dataModel());
      Navigator.pushNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = HiveManager.dataBox.get('data') as dataModel;

    return Scaffold(
      body: Center(
        child: Text(data.goalStatement ?? "Not Set"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _confirmResetData();
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
