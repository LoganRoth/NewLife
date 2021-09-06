import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/track_data.dart';

class HabitData {
  int _id;
  int get id => _id;
  String name;
  HabitType type;
  Color catColor;
  DateTime creation;
  List<TrackData> trackingList;
  int index;
  int completed;
  int toComplete;
  int streak;
  bool isComplete;
  String uuid;
  DateTime lastReset;
  int longestStreak;

  HabitData(
    this._id, {
    @required this.completed,
    @required this.streak,
    @required this.creation,
    @required this.name,
    @required this.type,
    @required this.catColor,
    @required this.index,
    @required this.toComplete,
    @required this.uuid,
    @required this.lastReset,
    @required this.longestStreak,
  }) {
    this.isComplete = this.completed >= this.toComplete;
  }

  void setCompleted(int num) {
    completed = num;
    if (completed >= toComplete) {
      if (!isComplete) {
        isComplete = true;

        streak += 1;
      }
    } else if (isComplete) {
      isComplete = false;
      streak -= 1;
    }
  }

  void addPoint(DatabaseHelper dbHelper) async {
    if (completed < toComplete) {
      completed += 1;
      Map<String, dynamic> row = {
        DatabaseHelper.columnUuid: uuid,
        DatabaseHelper.columnTrackDate: DateTime.now().toIso8601String(),
      };
      if (completed >= toComplete) {
        isComplete = true;
        streak += 1;
        if (streak > longestStreak) {
          longestStreak = streak;
        }
      }

      if (type == HabitType.Day) {
        dbHelper.dayUpdate(makeDbRow());
      } else if (type == HabitType.Week) {
        dbHelper.weekUpdate(makeDbRow());
      } else if (type == HabitType.Month) {
        dbHelper.monthUpdate(makeDbRow());
      }
      dbHelper.trackInsert(row);
    }
  }

  void subtractPoint(DatabaseHelper dbHelper) async {
    if (completed > 0) {
      completed -= 1;
      if ((completed < toComplete) && (isComplete)) {
        streak -= 1;
        isComplete = false;
      }

      if (type == HabitType.Day) {
        dbHelper.dayUpdate(makeDbRow());
      } else if (type == HabitType.Week) {
        dbHelper.weekUpdate(makeDbRow());
      } else if (type == HabitType.Month) {
        dbHelper.monthUpdate(makeDbRow());
      }

      dbHelper.trackDeleteLast(uuid);
    }
  }

  void update() async {
    final dbHelper = DatabaseHelper.instance;
    if (type == HabitType.Day) {
      dbHelper.dayUpdate(makeDbRow());
    } else if (type == HabitType.Week) {
      dbHelper.weekUpdate(makeDbRow());
    } else if (type == HabitType.Month) {
      dbHelper.monthUpdate(makeDbRow());
    }
  }

  Map<String, dynamic> makeDbRow() {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnColour: catColor.value,
      DatabaseHelper.columnCreation: creation.toIso8601String(),
      DatabaseHelper.columnIndex: index,
      DatabaseHelper.columnCompleted: completed,
      DatabaseHelper.columnToComplete: toComplete,
      DatabaseHelper.columnStreak: streak,
      DatabaseHelper.columnUuid: uuid,
      DatabaseHelper.columnLastReset: lastReset.toIso8601String(),
      DatabaseHelper.columnLongestStreak: longestStreak,
    };
    return row;
  }

  Map<String, dynamic> makeTrackRow(TrackData td) {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: td.id,
      DatabaseHelper.columnUuid: td.uuid,
      DatabaseHelper.columnTrackDate: td.trackDT.toIso8601String(),
    };
    return row;
  }
}

enum HabitType {
  Day,
  Week,
  Month,
}
