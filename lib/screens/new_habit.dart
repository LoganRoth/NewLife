import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/widgets/colour_selector.dart';
import 'package:uuid/uuid.dart';

class NewHabitScreen extends StatefulWidget {
  static const routeName = '/new-habit';

  @override
  _NewHabitScreenState createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  final dbHelper = DatabaseHelper.instance;
  final _catColorFocusNode = FocusNode();
  final _toCompleteFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _selColour;
  int _toComplete;
  String _habitName;
  String name;

  var _currentlySelected;

  List<HabitType> _types = [
    HabitType.Day,
    HabitType.Week,
    HabitType.Month,
  ];

  @override
  void dispose() {
    _catColorFocusNode.dispose();
    _toCompleteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final Color myCol = _selColour;
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: _habitName,
        DatabaseHelper.columnColour: myCol.value,
        DatabaseHelper.columnCreation: DateTime.now().toIso8601String(),
        DatabaseHelper.columnIndex: 0,
        DatabaseHelper.columnCompleted: 0,
        DatabaseHelper.columnToComplete: _toComplete,
        DatabaseHelper.columnStreak: 0,
        DatabaseHelper.columnUuid: Uuid().v1(),
        DatabaseHelper.columnLastReset: DateTime.now().toIso8601String(),
        DatabaseHelper.columnLongestStreak: 0,
      };
      if (_types[_currentlySelected] == HabitType.Day) {
        final idx = await dbHelper.dayQueryRowCount();
        row[DatabaseHelper.columnIndex] = idx;
        await dbHelper.dayInsert(row);
      } else if (_types[_currentlySelected] == HabitType.Week) {
        final idx = await dbHelper.weekQueryRowCount();
        row[DatabaseHelper.columnIndex] = idx;
        await dbHelper.weekInsert(row);
      } else if (_types[_currentlySelected] == HabitType.Month) {
        final idx = await dbHelper.monthQueryRowCount();
        row[DatabaseHelper.columnIndex] = idx;
        await dbHelper.monthInsert(row);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void colourSet(Color selColour) {
    setState(() {
      _selColour = selColour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(
                "New Habit",
                style: TextStyle(
                  fontSize: 35.0,
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(
                "New Habit",
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Theme.of(context).buttonColor,
                    disabledTextColor: Colors.grey,
                    onPressed: _selColour == null ? null : _saveForm),
              ],
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText:
                                    'What is the habit you want to track?',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {},
                              onSaved: (value) {
                                _habitName = value;
                              },
                              validator: (value) {
                                var text;
                                if (value.isEmpty) {
                                  text = 'Please provide a name.';
                                } else {
                                  text = null;
                                }
                                return text;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    'Colour: ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (_selColour != null)
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: RaisedButton(
                                      shape: CircleBorder(),
                                      color: _selColour,
                                      onPressed: () {},
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ColourSelector(
                              colourSet: colourSet,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'How often do you want to track this habit?',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'For example: 2 times per day, or 3 times per week?',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      focusNode: _toCompleteFocusNode,
                                      onFieldSubmitted: (_) {},
                                      onSaved: (value) {
                                        _toComplete = int.tryParse(value);
                                      },
                                      validator: (value) {
                                        var text;
                                        if (value.isEmpty) {
                                          text = ' ';
                                        } else {
                                          if (int.tryParse(value) == null) {
                                            text = ' ';
                                          } else if (int.parse(value) <= 0) {
                                            text = ' ';
                                          } else {
                                            text = null;
                                          }
                                        }
                                        return text;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'times per ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: DropdownButtonFormField(
                                      dropdownColor: Colors.black,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      onChanged: (value) {
                                        _currentlySelected = value;
                                        setState(() {});
                                      },
                                      value: _currentlySelected,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('Day'),
                                          value: 0,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Week'),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Month'),
                                          value: 2,
                                        ),
                                      ],
                                      validator: (value) {
                                        var text;
                                        if ((value == null) ||
                                            (value < 0) ||
                                            (value >= 3)) {
                                          text = 'Please specify';
                                        } else {
                                          text = null;
                                        }
                                        return text;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
  }
}
