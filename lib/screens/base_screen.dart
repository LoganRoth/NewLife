import 'package:flutter/material.dart';
import 'package:new_life/pages/goals_page.dart';
import 'package:new_life/pages/habits_page.dart';
import 'package:new_life/pages/overview_page.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({Key key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String selPage = 'Overview';
  Map<String, Widget> pageMap = {};

  @override
  void initState() {
    pageMap['Overview'] = OverviewPage(changePageFunc: changePageFunc);
    pageMap['Habits'] = HabitsPage(changePageFunc: changePageFunc);
    pageMap['Goals'] = GoalsPage(changePageFunc: changePageFunc);
    super.initState();
  }

  void changePageFunc(String page) {
    setState(() {
      selPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageMap[selPage],
    );
  }
}
