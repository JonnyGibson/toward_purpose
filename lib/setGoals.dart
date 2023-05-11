import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/dataModel.dart';
import 'package:toward_purpose/viewGoal.dart';

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

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final data = dataProvider.data;

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
              )),
          Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'How will you do it?',
                  style: Gruppolarge(),
                ),
              )),
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.measurableTemplates?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.track_changes),
                            title: Text(
                              data.measurableTemplates?[index].name ?? "",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter new goal',
                    ),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_textEditingController.text.isNotEmpty) {
                          var mes = new Measurable()
                            ..generateId()
                            ..name = _textEditingController.text;
                          if (data.measurableTemplates == null)
                            data.measurableTemplates = [];
                          data.measurableTemplates?.add(mes);

                          _textEditingController.text = "";
                        }
                      });
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (data.measurableTemplates != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewGoal()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width / 2, 50),
                backgroundColor: secondaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Finish',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Image.asset(
                    'assets/toward.png',
                    width: 35.0,
                    height: 34.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
