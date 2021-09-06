import 'package:flutter/material.dart';
import 'package:new_life/functions/temp_dialog.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/widgets/colour_selector.dart';
import 'package:new_life/widgets/habit_calendar.dart';

class DetailHabitScreen extends StatefulWidget {
  static const routeName = '/detail-habit';

  @override
  _DetailHabitScreenState createState() => _DetailHabitScreenState();
}

class _DetailHabitScreenState extends State<DetailHabitScreen> {
  HabitData data;
  Color catColour;
  String name;
  String toComp;
  TextEditingController _nameTC = TextEditingController();
  TextEditingController _toCompTC = TextEditingController();
  bool isChangingColour = false;
  bool isViewingCal = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    data = ModalRoute.of(context).settings.arguments as HabitData;
    catColour = data.catColor;
    name = data.name;
    toComp = data.toComplete.toString();
    _nameTC.text = name;
    _nameTC.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameTC.text.length),
    );
    _toCompTC.text = toComp;
    _toCompTC.selection = TextSelection.fromPosition(
      TextPosition(offset: _toCompTC.text.length),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameTC.dispose();
    _toCompTC.dispose();
    super.dispose();
  }

  void colourSet(Color selColour) {
    catColour = selColour;
    data.catColor = catColour;
    data.update();
    setState(() {});
  }

  void updateName() {
    if (_nameTC.text.isNotEmpty) {
      name = _nameTC.text;
      data.name = name;
      data.update();
      setState(() {});
    }
  }

  void updateToComp(String val) {
    if (_toCompTC.text.isNotEmpty) {
      toComp = _toCompTC.text;
      int tmp = int.tryParse(toComp);
      if (tmp != null) {
        data.toComplete = tmp;
        data.update();
        setState(() {});
      }
    }
  }

  void deleteHabit() async {
    setState(() {
      isLoading = true;
    });
    final dbHelper = DatabaseHelper.instance;
    if (data.type == HabitType.Day) {
      await dbHelper.dayDelete(data.id, data.uuid);
    } else if (data.type == HabitType.Week) {
      await dbHelper.weekDelete(data.id, data.uuid);
    } else if (data.type == HabitType.Month) {
      await dbHelper.monthDelete(data.id, data.uuid);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void stateSetter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final streakStr = data.streak == 1
        ? data.type.toString().split(".").last
        : data.type.toString().split(".").last + 's';
    final lStreakStr = data.longestStreak == 1
        ? data.type.toString().split(".").last
        : data.type.toString().split(".").last + 's';
    final bool currIsLong = data.streak == data.longestStreak;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            color: Color(0xf0b71c1c),
            icon: Icon(Icons.delete),
            onPressed: () {
              tempDialog(
                context: context,
                title: 'Delete Habit',
                content: Text('Are you sure you want to delete this habit?'),
                button1: 'Delete',
                button1Action: deleteHabit,
              );
            },
          ),
        ],
        title: Text(
          name,
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: catColour,
                    child: Text(''),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Text(
                          'Name: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            onEditingComplete: updateName,
                            controller: _nameTC,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Times Completed This Period: ${data.completed}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Text(
                          'Times To Complete: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: TextFormField(
                            onChanged: updateToComp,
                            controller: _toCompTC,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChangingColour = !isChangingColour;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 15.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              'Colour',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text('')),
                          Icon(
                            isChangingColour
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isChangingColour)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ColourSelector(colourSet: colourSet),
                    ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isViewingCal = !isViewingCal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 15.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              'View Calendar',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text('')),
                          Icon(
                            isViewingCal
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isViewingCal)
                    HabitCalendar(
                      data: data,
                      downSet: stateSetter,
                    ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Current Streak: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${data.streak} $streakStr',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: currIsLong ? catColour : Colors.white,
                            fontWeight: currIsLong
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Longest Streak: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${data.longestStreak} $lStreakStr',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: currIsLong ? catColour : Colors.white,
                            fontWeight: currIsLong
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
    );
  }
}
