import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/goal_data.dart';
import 'package:new_life/widgets/one_goal.dart';

class Goals extends StatefulWidget {
  final List<GoalData> dataSet;
  final Function refreshFunc;

  Goals({
    @required this.dataSet,
    @required this.refreshFunc,
  });

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final dbHelper = DatabaseHelper.instance;

  Map<String, dynamic> makeDbRow(GoalData dataObj) {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: dataObj.id,
      DatabaseHelper.columnName: dataObj.name,
      DatabaseHelper.columnColour: dataObj.catColor.value,
      DatabaseHelper.columnCreation: dataObj.creation.toIso8601String(),
      DatabaseHelper.columnIndex: 0,
      DatabaseHelper.columnCompleted: dataObj.completed,
      DatabaseHelper.columnToComplete: dataObj.toComplete,
      DatabaseHelper.columnGoalsUnits: dataObj.units,
      DatabaseHelper.columnGoalsStyle: dataObj.style.index,
    };
    return row;
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final item = widget.dataSet.removeAt(oldindex);
      widget.dataSet.insert(newindex, item);
    });
    int idx = 0;
    widget.dataSet.forEach((element) {
      Map<String, dynamic> row = makeDbRow(element);
      row[DatabaseHelper.columnIndex] = idx;
      dbHelper.goalsUpdate(row);
      idx++;
    });
  }

  Widget goalList() {
    List<OneGoal> tmpList = [];
    widget.dataSet.forEach((oneData) {
      tmpList.add(
        OneGoal(
          data: oneData,
          key: ValueKey(oneData.id),
          update: widget.refreshFunc,
        ),
      );
    });
    return ReorderableListView(children: tmpList, onReorder: reorderData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: widget.dataSet.isEmpty
          ? Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Create your first Goal!',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    AutoSizeText(
                      'Press the +',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : goalList(),
    );
  }
}
