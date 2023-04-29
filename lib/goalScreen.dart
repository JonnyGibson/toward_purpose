import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:toward_purpose/viewGoal.dart';

import 'dataModel.dart';

final Color primaryColor = Color.fromRGBO(243, 198, 152, 1.0);
final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dataBox = Hive.box<dataModel>('dataBox');
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
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Enter your goal here',
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final text = _textEditingController.text;
                if (text.isNotEmpty) {
                  final data = dataBox.get('data') ?? dataModel();
                  data.goalStatement = text;
                  dataBox.put('data', data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewGoal()),
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
                color: primaryColor.withOpacity(0.5),
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
  bool _showFirst = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 7), (_) {
      setState(() {
        _showFirst = !_showFirst;
        _currentGoal = getRandomPersonalGoal(personalGoals);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 700),
      crossFadeState:
          _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Text(
        _currentGoal,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24.0, color: accentColor),
      ),
      secondChild: Text(
        getRandomPersonalGoal(personalGoals),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24.0, color: accentColor),
      ),
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
