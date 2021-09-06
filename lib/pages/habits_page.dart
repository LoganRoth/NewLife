import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dart_date/dart_date.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/screens/all_habits.dart';
import 'package:new_life/screens/habits.dart';
import 'package:new_life/screens/new_habit.dart';
import 'package:new_life/widgets/main_drawer.dart';

class HabitsPage extends StatefulWidget {
  final Function changePageFunc;
  HabitsPage({this.changePageFunc});

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final dbHelper = DatabaseHelper.instance;
  PageController _pageController;
  int _pageIdx = 0;
  List<HabitData> dailyHabits = [];
  List<HabitData> weeklyHabits = [];
  List<HabitData> monthlyHabits = [];
  bool _isLoading = true;

  // State Functions
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTap(int idx) {
    _pageController.animateToPage(idx,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onPageChanged(int idx) {
    setState(() {
      _pageIdx = idx;
    });
  }

  void createNewHabit() async {
    await Navigator.of(context).pushNamed(NewHabitScreen.routeName);
    await getData(isInit: true);
  }

  void initData() async {
    await getData(isInit: true);
  }

  Future<void> getData({bool isInit = false}) async {
    List<Map<String, dynamic>> _dayData = await dbHelper.dayQueryAllRows();
    List<Map<String, dynamic>> _weekData = await dbHelper.weekQueryAllRows();
    List<Map<String, dynamic>> _monthData = await dbHelper.monthQueryAllRows();
    dailyHabits = [];
    weeklyHabits = [];
    monthlyHabits = [];
    _dayData.forEach((oneData) async {
      Map<String, dynamic> resetData = checkReset(HabitType.Day, oneData);
      dailyHabits.add(
        HabitData(
          oneData[DatabaseHelper.columnId],
          completed: resetData['completed'],
          streak: resetData['streak'],
          creation: DateTime.parse(oneData[DatabaseHelper.columnCreation]),
          name: oneData[DatabaseHelper.columnName],
          type: HabitType.Day,
          catColor: Color(oneData[DatabaseHelper.columnColour]),
          index: oneData[DatabaseHelper.columnIndex],
          toComplete: oneData[DatabaseHelper.columnToComplete],
          uuid: oneData[DatabaseHelper.columnUuid],
          lastReset: resetData['resetDate'],
          longestStreak: oneData[DatabaseHelper.columnLongestStreak],
        ),
      );
    });
    _weekData.forEach((oneData) async {
      Map<String, dynamic> resetData = checkReset(HabitType.Week, oneData);
      weeklyHabits.add(
        HabitData(
          oneData[DatabaseHelper.columnId],
          completed: resetData['completed'],
          streak: resetData['streak'],
          creation: DateTime.parse(oneData[DatabaseHelper.columnCreation]),
          name: oneData[DatabaseHelper.columnName],
          type: HabitType.Week,
          catColor: Color(oneData[DatabaseHelper.columnColour]),
          index: oneData[DatabaseHelper.columnIndex],
          toComplete: oneData[DatabaseHelper.columnToComplete],
          uuid: oneData[DatabaseHelper.columnUuid],
          lastReset: resetData['resetDate'],
          longestStreak: oneData[DatabaseHelper.columnLongestStreak],
        ),
      );
    });
    _monthData.forEach((oneData) async {
      Map<String, dynamic> resetData = checkReset(HabitType.Month, oneData);
      monthlyHabits.add(
        HabitData(
          oneData[DatabaseHelper.columnId],
          completed: resetData['completed'],
          streak: resetData['streak'],
          creation: DateTime.parse(oneData[DatabaseHelper.columnCreation]),
          name: oneData[DatabaseHelper.columnName],
          type: HabitType.Month,
          catColor: Color(oneData[DatabaseHelper.columnColour]),
          index: oneData[DatabaseHelper.columnIndex],
          toComplete: oneData[DatabaseHelper.columnToComplete],
          uuid: oneData[DatabaseHelper.columnUuid],
          lastReset: resetData['resetDate'],
          longestStreak: oneData[DatabaseHelper.columnLongestStreak],
        ),
      );
    });
    _isLoading = false;
    if (isInit) {
      setState(() {});
    }
    return;
  }

  Map<String, dynamic> checkReset(
      HabitType type, Map<String, dynamic> oneData) {
    Map<String, dynamic> resetData = {
      'resetDate': DateTime.parse(oneData[DatabaseHelper.columnLastReset]),
      'completed': oneData[DatabaseHelper.columnCompleted],
      'streak': oneData[DatabaseHelper.columnStreak],
    };
    DateTime currLastReset =
        DateTime.parse(oneData[DatabaseHelper.columnLastReset]);
    DateTime today = DateTime.now();

    if (type == HabitType.Week) {
      if ((today.difference(currLastReset).inDays >= 7) ||
          today.isAfter(currLastReset.endOfWeek)) {
        // Will reset week habits
        currLastReset = today;
        resetData['completed'] = 0;
        if (oneData[DatabaseHelper.columnToComplete] !=
            oneData[DatabaseHelper.columnCompleted]) {
          // Reset the streak to 0, streak has failed!
          resetData['streak'] = 0;
        }
      }
    } else {
      if ((today.year > currLastReset.year) ||
          (today.month > currLastReset.month)) {
        // Will always reset month and day habits
        currLastReset = today;
        resetData['completed'] = 0;
        if (oneData[DatabaseHelper.columnToComplete] !=
            oneData[DatabaseHelper.columnCompleted]) {
          // Reset the streak to 0, streak has failed!
          resetData['streak'] = 0;
        }
      } else if ((type == HabitType.Day) && (today.day > currLastReset.day)) {
        // Will always reset day habits
        currLastReset = today;
        resetData['completed'] = 0;
        if (oneData[DatabaseHelper.columnToComplete] !=
            oneData[DatabaseHelper.columnCompleted]) {
          // Reset the streak to 0, streak has failed!
          resetData['streak'] = 0;
        }
      }
    }

    resetData['resetDate'] = currLastReset;

    return resetData;
  }

  Future<void> _pullRefresh() async {
    getData(isInit: true);
  }

  Widget buildHabitsScreen() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _pageIdx == 0
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).primaryColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () => onTap(0),
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _pageIdx == 1
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).primaryColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FlatButton(
                    onPressed: () => onTap(1),
                    child: Text(
                      'Day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _pageIdx == 2
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).primaryColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FlatButton(
                    onPressed: () => onTap(2),
                    child: Text(
                      'Week',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _pageIdx == 3
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).primaryColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FlatButton(
                    onPressed: () => onTap(3),
                    child: Text(
                      'Month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                AllHabits(
                  dataSets: [dailyHabits, weeklyHabits, monthlyHabits],
                  refreshFunc: _pullRefresh,
                ),
                Habits(
                  dataSet: dailyHabits,
                  type: HabitType.Day,
                  refreshFunc: _pullRefresh,
                ),
                Habits(
                  dataSet: weeklyHabits,
                  type: HabitType.Week,
                  refreshFunc: _pullRefresh,
                ),
                Habits(
                  dataSet: monthlyHabits,
                  type: HabitType.Month,
                  refreshFunc: _pullRefresh,
                ),
              ],
              controller: _pageController,
              onPageChanged: onPageChanged,
            ),
          ),
        ],
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
                'Your Habits',
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
                  onPressed: createNewHabit,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                'Your Habits',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                  ),
                  onPressed: createNewHabit,
                ),
              ],
            ),
            body: buildHabitsScreen(),
            drawer: MainDrawer(
              changePageFunc: widget.changePageFunc,
            ),
          );
  }
}
