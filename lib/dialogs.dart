import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/goalDefine.dart';
import 'package:uuid/uuid.dart';

import 'dataModel.dart';
import 'dataProvider.dart';

void showAddDayDialog(BuildContext context) {
  final dataProvider = context.read<DataProvider>();
  if (dataProvider.data.days == null) dataProvider.data.days = [];

  var day = dataProvider.data.getToday(DateTime.now());
  if (day == null) {
    dataProvider.data.days
        ?.add(Day(id: Uuid().v4(), date: DateTime.now(), dailyScore: 0));
    day = dataProvider.data.getToday(DateTime.now());
  }
  var originalText = day?.qualitativeComment;
  var originalScore = day?.dailyScore;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          int _selectedValue = day?.dailyScore ?? 0;
          List<int> _values = [-2, -1, 0, 1, 2];
          return AlertDialog(
            title: Text("How was your day?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText:
                        day?.qualitativeComment ?? "Qualitative Statement",
                  ),
                  onChanged: (value) {
                    day?.qualitativeComment = value;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How did it feel?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _values.map((value) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValue = value;
                              });
                              _selectedValue = value;
                              day?.dailyScore = value;
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                                color: _selectedValue == value
                                    ? secondaryColor
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ).paddingAll(3),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  day?.dailyScore = originalScore;
                  day?.qualitativeComment = originalText;
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  day?.dailyScore = _selectedValue;
                  dataProvider.saveData();
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
