import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoalScreen(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(-50, -150),
                child: Image.asset(
                  'assets/toward.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Transform.translate(
                offset: Offset(0, -150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'What is it',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'that you want?',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your goal here',
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width / 3, 50),
                          backgroundColor:
                              secondaryColor, // set the button's background color to green
                        ),
                        child: Row(
                          //  mainAxisSize: MainAxisSize.min,
                          //  mainAxisAlignment: MainAxisAlignment
                          //   .center, // set the main axis size to min to reduce the button's width
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                                width:
                                    8.0), // add some spacing between the label and icon
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
              ),
              Transform.translate(
                  offset: Offset(0, -50),
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
        ],
      ),
    ));
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
