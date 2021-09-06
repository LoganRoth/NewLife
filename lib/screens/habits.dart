import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/widgets/one_habit.dart';
import 'package:new_life/helpers/database_helper.dart';

class Habits extends StatefulWidget {
  final List<HabitData> dataSet;
  final HabitType type;
  final Function refreshFunc;

  Habits({
    @required this.dataSet,
    @required this.type,
    @required this.refreshFunc,
  });

  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final dbHelper = DatabaseHelper.instance;

  ReorderableListView oneList(List<HabitData> data) {
    List<OneHabit> tmpList = [];
    data.forEach((oneData) {
      tmpList.add(
        OneHabit(
          data: oneData,
          key: ValueKey(oneData.id),
          update: widget.refreshFunc,
        ),
      );
    });
    return ReorderableListView(
      onReorder: reorderData,
      children: tmpList,
    );
  }

  Map<String, dynamic> makeDbRow(HabitData dataObj) {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: dataObj.id,
      DatabaseHelper.columnName: dataObj.name,
      DatabaseHelper.columnColour: dataObj.catColor.value,
      DatabaseHelper.columnCreation: dataObj.creation.toIso8601String(),
      DatabaseHelper.columnIndex: 0,
      DatabaseHelper.columnCompleted: dataObj.completed,
      DatabaseHelper.columnToComplete: dataObj.toComplete,
      DatabaseHelper.columnStreak: dataObj.streak,
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
    if (widget.type == HabitType.Day) {
      widget.dataSet.forEach((element) {
        Map<String, dynamic> row = makeDbRow(element);
        row[DatabaseHelper.columnIndex] = idx;
        dbHelper.dayUpdate(row);
        idx++;
      });
    } else if (widget.type == HabitType.Week) {
      widget.dataSet.forEach((element) {
        Map<String, dynamic> row = makeDbRow(element);
        row[DatabaseHelper.columnIndex] = idx;
        dbHelper.dayUpdate(row);
        idx++;
      });
    } else if (widget.type == HabitType.Month) {
      widget.dataSet.forEach((element) {
        Map<String, dynamic> row = makeDbRow(element);
        row[DatabaseHelper.columnIndex] = idx;
        dbHelper.dayUpdate(row);
        idx++;
      });
    }
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
                      'Create your first ${widget.type.toString().split('.').last} Habit!',
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
          : RefreshIndicator(
              onRefresh: widget.refreshFunc,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  child: oneList(widget.dataSet),
                ),
              ),
            ),
    );
  }
}
