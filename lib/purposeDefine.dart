import 'dart:async';
import 'dart:math';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataProvider.dart';

import 'setGoals.dart';
import 'styles.dart';

class PurposeDefine extends StatefulWidget {
  const PurposeDefine({Key? key}) : super(key: key);

  @override
  _PurposeDefineState createState() => _PurposeDefineState();
}

class _PurposeDefineState extends State<PurposeDefine> {
  var _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    _textEditingController.text = dataProvider.data.goalStatement ?? "";
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
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'What is it\nthat you want?',
              style: Gruppolarge(),
            ),
          ),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter your purpose statement',
              contentPadding: EdgeInsets.all(16.0),
            ),
          ).paddingLTRB(20, 0, 20, 0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final text = _textEditingController.text;
                if (text.isNotEmpty) {
                  dataProvider.data.goalStatement = text;
                  dataProvider.data.generateId();
                  dataProvider.saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SetGoals()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width / 3, 50),
                backgroundColor: secondaryColor,
              ),
              child: Row(
                children: [
                  Text(
                    'Next',
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
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: primaryColor?.withOpacity(0.2),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: GoalText(),
                ),
                alignment: Alignment.bottomCenter,
              ))
        ],
      ),
    );
  }
}

class GoalText extends StatefulWidget {
  const GoalText({Key? key}) : super(key: key);

  @override
  _GoalTextState createState() => _GoalTextState();
}

class _GoalTextState extends State<GoalText> {
  String _currentGoal = getRandomPersonalGoal(personalGoals);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (_) {
      setState(() {
        _currentGoal = getRandomPersonalGoal(personalGoals);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentGoal,
      textAlign: TextAlign.center,
      style: GruppoMedium().copyWith(color: accentColor),
    );
  }
}

List<String> personalGoals = [
  'Improve physical health and fitness by exercising regularly, eating a healthy diet, and getting enough rest.',
  'Enhance mental health and well-being by practicing mindfulness, meditation, or other forms of self-care.',
  'Learn a new skill or take up a new hobby that brings joy and satisfaction.',
  'Improve time management skills to better prioritize tasks and increase productivity.',
  'Develop stronger communication skills to improve relationships with friends, family, or colleagues.',
  'Build confidence and self-esteem by setting achievable goals and celebrating small successes.',
  'Develop a growth mindset to embrace challenges and learn from failures.',
  'Improve financial literacy and management to achieve financial stability and security.',
  'Cultivate a positive attitude and gratitude mindset to appreciate life\'s blessings and increase happiness.',
  'Improve organizational skills to reduce stress and create a more orderly environment.'
];

String getRandomPersonalGoal(List<String> goals) {
  final random = Random();
  return goals[random.nextInt(goals.length)];
}
