import 'package:flutter/material.dart';
import 'package:new_life/screens/base_screen.dart';
import 'package:new_life/screens/goal_detail_screen.dart';
import 'package:new_life/screens/habit_detail_screen.dart';
import 'package:new_life/screens/new_goal.dart';
import 'package:new_life/screens/new_habit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Life',
      theme: ThemeData(
        primaryColor: Colors.grey[900],
        primaryColorDark: Colors.black,
        buttonColor: Colors.blue,
        backgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BaseScreen(),
      routes: {
        NewGoalScreen.routeName: (ctx) => NewGoalScreen(),
        NewHabitScreen.routeName: (ctx) => NewHabitScreen(),
        DetailHabitScreen.routeName: (ctx) => DetailHabitScreen(),
        DetailGoalScreen.routeName: (ctx) => DetailGoalScreen(),
      },
      onGenerateRoute: (_) {
        // Will go here on routes NOT registered
        return MaterialPageRoute(
          builder: (ctx) => BaseScreen(),
        );
      },
      onUnknownRoute: (_) {
        // Last resort to show "something" like 404 Error
        return MaterialPageRoute(
          builder: (ctx) => BaseScreen(),
        );
      },
    );
  }
}
