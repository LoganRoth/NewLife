import 'package:flutter/material.dart';
import 'package:new_life/functions/temp_dialog.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/goal_data.dart';
import 'package:new_life/widgets/colour_selector.dart';
import 'package:uuid/uuid.dart';

class NewGoalScreen extends StatefulWidget {
  static const routeName = '/new-goal';

  @override
  _NewGoalScreenState createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends State<NewGoalScreen> {
  final dbHelper = DatabaseHelper.instance;
  GoalsStyle _goalStyle = GoalsStyle.Completion;
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _selColour;
  double _toComplete = 1;
  String _goalUnits = '';
  String _goalName;

  @override
  void dispose() {
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
      if (_goalStyle == GoalsStyle.Completion) {
        _toComplete = 1;
        _goalUnits = '';
      }
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: _goalName,
        DatabaseHelper.columnColour: myCol.value,
        DatabaseHelper.columnCreation: DateTime.now().toIso8601String(),
        DatabaseHelper.columnIndex: 0,
        DatabaseHelper.columnCompleted: 0.0,
        DatabaseHelper.columnToComplete: _toComplete,
        DatabaseHelper.columnUuid: Uuid().v1(),
        DatabaseHelper.columnGoalsUnits: _goalUnits,
        DatabaseHelper.columnGoalsStyle: _goalStyle.index,
      };
      final idx = await dbHelper.goalsQueryRowCount();
      row[DatabaseHelper.columnIndex] = idx;
      await dbHelper.goalsInsert(row);
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
                "New Goal",
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
                "New Goal",
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
                                    'What is the goal you want to track?',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {},
                              onSaved: (value) {
                                _goalName = value;
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
                              'How do you want to track this goal?',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text(
                                      'Completion',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'Track when the goal is completed',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _goalStyle = GoalsStyle.Completion;
                                      });
                                    },
                                    leading: Radio<GoalsStyle>(
                                      value: GoalsStyle.Completion,
                                      groupValue: _goalStyle,
                                      onChanged: (GoalsStyle value) {
                                        setState(() {
                                          _goalStyle = value;
                                        });
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.help_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        tempDialog(
                                          context: context,
                                          oneButton: true,
                                          button1: 'Ok',
                                          title: 'Completion',
                                          content: Text(
                                              'This is option is for your goal if it is '
                                              'something you are working towards '
                                              'that you would do once.\n\nFor '
                                              'example:\nYour goal is to run a '
                                              'marathon. When you run a '
                                              'marathon, you track it.'),
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'Set your current progress towards your goal each time you track it',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _goalStyle = GoalsStyle.Progress;
                                      });
                                    },
                                    leading: Radio<GoalsStyle>(
                                      value: GoalsStyle.Progress,
                                      groupValue: _goalStyle,
                                      onChanged: (GoalsStyle value) {
                                        setState(() {
                                          _goalStyle = value;
                                        });
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.help_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        tempDialog(
                                          context: context,
                                          oneButton: true,
                                          button1: 'Ok',
                                          title: 'Progress',
                                          content: Text(
                                              'This is option is for your goal if it is '
                                              'something you are working towards '
                                              'that you would do in chunks.\n\nFor '
                                              'example:\nYour goal is to be able '
                                              'to bench press 200 lbs. Each time '
                                              'you get a new personal best, you '
                                              'set your current progress.'),
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Cumulative',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'Add towards your current progress each time you track it',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _goalStyle = GoalsStyle.Cumulative;
                                      });
                                    },
                                    leading: Radio<GoalsStyle>(
                                      value: GoalsStyle.Cumulative,
                                      groupValue: _goalStyle,
                                      onChanged: (GoalsStyle value) {
                                        setState(() {
                                          _goalStyle = value;
                                        });
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.help_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        tempDialog(
                                          context: context,
                                          oneButton: true,
                                          button1: 'Ok',
                                          title: 'Cumulative',
                                          content: Text(
                                              'This is option is for your goal if it is '
                                              'something you are working towards '
                                              'that you would do in inconsistent '
                                              'chunks.\n\nFor example:\nYour '
                                              'goal is to run 100 '
                                              'km. Each time you go for a run, '
                                              'you add towards your goal.'),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            if ((_goalStyle == GoalsStyle.Progress) ||
                                (_goalStyle == GoalsStyle.Cumulative))
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText:
                                            'What is the numerical value of the goal?',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      onFieldSubmitted: (_) {},
                                      onSaved: (value) {
                                        _toComplete = double.tryParse(value);
                                      },
                                      validator: (value) {
                                        var text;
                                        if (value.isEmpty) {
                                          text =
                                              'Please provide a numerical goal.';
                                        } else if (double.tryParse(value) ==
                                            null) {
                                          text = 'Goal must be a number';
                                        } else {
                                          text = null;
                                        }
                                        return text;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText:
                                            'What units should be used? (Optional)',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) {},
                                      onSaved: (value) {
                                        _goalUnits = value;
                                      },
                                      validator: (value) {
                                        var text;
                                        if (value.isNotEmpty &&
                                            value.length > 10) {
                                          text =
                                              'Units cannt be more than 10 characters.';
                                        } else {
                                          text = null;
                                        }
                                        return text;
                                      },
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
