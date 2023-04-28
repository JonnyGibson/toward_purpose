import 'package:flutter/material.dart';

import 'goalScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Toward Purpose',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(243, 198, 152, 1.0);
  final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
  final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toward Purpose',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: accentColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: secondaryColor,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
      ),
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.0, bottom: 50),
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
            Text(
              'Toward Purpose',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Expanded(
                child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoalScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Get Started'),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
