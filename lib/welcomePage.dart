import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/generateTestData.dart';
import 'package:toward_purpose/viewGoal.dart';
import 'dataProvider.dart';
import 'styles.dart';
import 'goalDefine.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Image.asset(
                  'assets/toward.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Toward',
                    style: Gruppolarge(),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Purpose',
                    style: Gruppolarge(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalDefine()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Get Started'),
              ),
            ),
          )),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  var testData = generateTestData();
                  final dataProvider = context.read<DataProvider>();
                  dataProvider.clearData();
                  dataProvider.data = testData;
                  dataProvider.saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewGoal()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Generate Test Data'),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
