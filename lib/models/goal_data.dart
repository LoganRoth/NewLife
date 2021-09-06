import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';

class GoalData {
  int _id;
  int get id => _id;
  String name;
  Color catColor;
  DateTime creation;
  String uuid;
  int index;
  double completed;
  double toComplete;
  bool isComplete;
  String units;
  GoalsStyle style;

  GoalData(
    this._id, {
    @required this.creation,
    @required this.name,
    @required this.catColor,
    @required this.uuid,
    @required this.completed,
    @required this.toComplete,
    @required this.units,
    @required this.style,
    @required this.index,
  }) {
    this.isComplete = this.completed >= this.toComplete;
  }

  void setProgress(DatabaseHelper dbHelper, double num) {
    if (num > toComplete) {
      num = toComplete;
    } else if (num < 0.0) {
      num = 0.0;
    }
    if (num <= toComplete) {
      completed = num;
      dbHelper.goalsUpdate(makeDbRow(num));
    }

    if (num == toComplete) {
      isComplete = true;
    } else {
      isComplete = false;
    }
  }

  Map<String, dynamic> makeDbRow(double num) {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnColour: catColor.value,
      DatabaseHelper.columnCreation: creation.toIso8601String(),
      DatabaseHelper.columnIndex: index,
      DatabaseHelper.columnCompleted: num,
      DatabaseHelper.columnToComplete: toComplete,
      DatabaseHelper.columnUuid: uuid,
      DatabaseHelper.columnGoalsUnits: units,
      DatabaseHelper.columnGoalsStyle: style.index,
    };
    return row;
  }

  void update() async {
    if (completed == toComplete) {
      isComplete = true;
    } else {
      isComplete = false;
    }
    final dbHelper = DatabaseHelper.instance;
    dbHelper.goalsUpdate(makeDbRow(completed));
  }
}

enum GoalsStyle {
  Completion,
  Progress,
  Cumulative,
}
