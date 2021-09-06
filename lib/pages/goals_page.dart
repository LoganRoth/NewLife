import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/goal_data.dart';
import 'package:new_life/screens/goals.dart';
import 'package:new_life/screens/new_goal.dart';
import 'package:new_life/widgets/main_drawer.dart';

class GoalsPage extends StatefulWidget {
  final Function changePageFunc;
  GoalsPage({this.changePageFunc});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final dbHelper = DatabaseHelper.instance;
  List<GoalData> _goals = [];
  bool _isLoading = true;

  // State Functions
  @override
  void initState() {
    super.initState();
    initData();
  }

  void createNewGoal() async {
    await Navigator.of(context).pushNamed(NewGoalScreen.routeName);
    await getData(isInit: true);
  }

  void initData() async {
    await getData(isInit: true);
  }

  Future<void> getData({bool isInit = false}) async {
    List<Map<String, dynamic>> goalsData = await dbHelper.goalsQueryAllRows();
    _goals = [];
    goalsData.forEach((oneData) async {
      _goals.add(
        GoalData(
          oneData[DatabaseHelper.columnId],
          completed: oneData[DatabaseHelper.columnCompleted],
          creation: DateTime.parse(oneData[DatabaseHelper.columnCreation]),
          name: oneData[DatabaseHelper.columnName],
          catColor: Color(oneData[DatabaseHelper.columnColour]),
          index: oneData[DatabaseHelper.columnIndex],
          toComplete: oneData[DatabaseHelper.columnToComplete],
          uuid: oneData[DatabaseHelper.columnUuid],
          units: oneData[DatabaseHelper.columnGoalsUnits],
          style: GoalsStyle.values[oneData[DatabaseHelper.columnGoalsStyle]],
        ),
      );
    });
    _isLoading = false;
    if (isInit) {
      setState(() {});
    }
    return;
  }

  Future<void> _pullRefresh() async {
    getData(isInit: true);
  }

  Widget buildGoalsScreen() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        child: Goals(
          dataSet: _goals,
          refreshFunc: _pullRefresh,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: Text(
                'Your Goals',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: Container(
              height: 65.0,
              width: 65.0,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: createNewGoal,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                'Your Goals',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                  ),
                  onPressed: createNewGoal,
                ),
              ],
            ),
            drawer: MainDrawer(
              changePageFunc: widget.changePageFunc,
            ),
            body: buildGoalsScreen(),
          );
  }
}
