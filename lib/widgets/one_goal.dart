import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_life/functions/temp_dialog.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/goal_data.dart';
import 'package:new_life/screens/goal_detail_screen.dart';

class OneGoal extends StatefulWidget {
  final GoalData data;
  final Key key;
  final Function update;

  OneGoal({
    @required this.data,
    @required this.key,
    @required this.update,
  });

  @override
  _OneGoalState createState() => _OneGoalState();
}

class _OneGoalState extends State<OneGoal> {
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController _controller = TextEditingController();
  var _setNum;

  void addPoint(BuildContext context) async {
    if (widget.data.style == GoalsStyle.Completion) {
      widget.data.setProgress(dbHelper, 1.0);
    } else if (widget.data.style == GoalsStyle.Progress) {
      await _showDialog(title: 'Set Current Progress');
      if (_setNum != null) {
        final progress = _setNum;
        widget.data.setProgress(dbHelper, progress);
      }
    } else if (widget.data.style == GoalsStyle.Cumulative) {
      await _showDialog(title: 'Add To Current Progress');
      if (_setNum != null) {
        final cumulative = widget.data.completed + _setNum;
        widget.data.setProgress(dbHelper, cumulative);
      }
    } else {
      print('Should not reach');
    }
    setState(() {
      _controller.text = '';
      _setNum = null;
    });
  }

  void subtractPoint(BuildContext ctx) async {
    if (widget.data.style == GoalsStyle.Completion) {
      widget.data.setProgress(dbHelper, 0.0);
    } else if (widget.data.style == GoalsStyle.Progress) {
      await _showDialog(title: 'Set Current Progress');
      if (_setNum != null) {
        final progress = _setNum;
        widget.data.setProgress(dbHelper, progress);
      }
    } else if (widget.data.style == GoalsStyle.Cumulative) {
      await _showDialog(title: 'Subtract From Current Progress');
      if (_setNum != null) {
        final cumulative = widget.data.completed - _setNum;
        widget.data.setProgress(dbHelper, cumulative);
      }
    } else {
      print('Should not reach');
    }
    setState(() {
      _controller.text = '';
      _setNum = null;
    });
  }

  _showDialog({String title}) async {
    await showDialog<String>(
      context: context,
      child: _SystemPadding(
        child: Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Card(
                  color: Colors.grey,
                  borderOnForeground: false,
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      _controller.text = '';
                      _setNum = null;
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Done'),
                    onPressed: () {
                      final testNum = double.tryParse(_controller.text);
                      if (testNum != null) {
                        _setNum = testNum;
                      } else {
                        _setNum = null;
                      }
                      _controller.text = '';
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(title),
                content: Card(
                  color: Colors.grey,
                  borderOnForeground: false,
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      _controller.text = '';
                      _setNum = null;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: const Text('Done'),
                    onPressed: () {
                      final testNum = double.tryParse(_controller.text);
                      if (testNum != null) {
                        _setNum = testNum;
                      } else {
                        _setNum = null;
                      }
                      _controller.text = '';
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  void goToDetail() async {
    await Navigator.of(context)
        .pushNamed(DetailGoalScreen.routeName, arguments: widget.data);
    widget.update();
  }

  @override
  Widget build(BuildContext context) {
    final numComp = num.parse(widget.data.completed.toStringAsFixed(2));
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      child: GestureDetector(
        onTap: () {
          addPoint(context);
        },
        onDoubleTap: () {
          subtractPoint(context);
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              color: widget.data.catColor,
              height: 5,
              width: MediaQuery.of(context).size.width *
                  (widget.data.completed / widget.data.toComplete),
              child: Text(""),
            ),
            Positioned(
              left: 5.0,
              width: MediaQuery.of(context).size.height * 0.07,
              top: MediaQuery.of(context).size.height * 0.015,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Container(
                child: Text(''),
                decoration: BoxDecoration(
                  color: widget.data.catColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height * 0.075 + 5.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: widget.data.isComplete
                              ? Color(0xffffd700)
                              : Colors.white,
                          size: widget.data.isComplete
                              ? MediaQuery.of(context).size.height * 0.04
                              : MediaQuery.of(context).size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                          if (widget.data.style != GoalsStyle.Completion)
                            Text(
                              "$numComp ${widget.data.units}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: widget.data.isComplete
                                    ? FontWeight.bold
                                    : null,
                                color: widget.data.isComplete
                                    ? widget.data.catColor
                                    : Colors.grey[400],
                              ),
                            ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      color: Colors.white,
                      onPressed: goToDetail,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
