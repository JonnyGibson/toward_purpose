import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dataProvider.dart';
import 'viewGoal.dart';
import 'welcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataProvider = DataProvider();
  await dataProvider.loadData();
  runApp(
    ChangeNotifierProvider(
      create: (_) => dataProvider,
      child: MaterialApp(
        title: 'Toward Purpose',
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(243, 198, 152, 1.0);
  final Color secondaryColor = Color.fromRGBO(140, 148, 89, 1.0);
  final Color accentColor = Color.fromRGBO(210, 130, 90, 1.0);

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final data = dataProvider.data;

    return MaterialApp(
        title: 'Toward Purpose',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => WelcomePage());
            case '/viewgoal':
              return MaterialPageRoute(builder: (context) => ViewGoal());
            default:
              return MaterialPageRoute(builder: (context) => WelcomePage());
          }
        },
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: secondaryColor,
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
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: accentColor),
        ),
        home: data.goalStatement?.isNotEmpty != null
            ? ViewGoal()
            : WelcomePage());
  }
}
