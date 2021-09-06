import 'package:flutter/material.dart';
import 'package:new_life/functions/temp_dialog.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/goal_data.dart';
import 'package:new_life/widgets/colour_selector.dart';

class DetailGoalScreen extends StatefulWidget {
  static const routeName = '/detail-goal';

  @override
  _DetailGoalScreenState createState() => _DetailGoalScreenState();
}

class _DetailGoalScreenState extends State<DetailGoalScreen> {
  GoalData data;
  Color catColour;
  String name;
  String toComp;
  String units;
  TextEditingController _nameTC = TextEditingController();
  TextEditingController _toCompTC = TextEditingController();
  TextEditingController _unitsTC = TextEditingController();
  bool isChangingColour = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    data = ModalRoute.of(context).settings.arguments as GoalData;
    catColour = data.catColor;
    name = data.name;
    toComp = data.toComplete.toString();
    units = data.units;
    _nameTC.text = name;
    _nameTC.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameTC.text.length),
    );
    _toCompTC.text = toComp;
    _toCompTC.selection = TextSelection.fromPosition(
      TextPosition(offset: _toCompTC.text.length),
    );
    _unitsTC.text = units;
    _unitsTC.selection = TextSelection.fromPosition(
      TextPosition(offset: _unitsTC.text.length),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameTC.dispose();
    _toCompTC.dispose();
    _unitsTC.dispose();
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
      double tmp = double.tryParse(toComp);
      if (tmp != null) {
        data.toComplete = tmp;
        data.update();
        setState(() {});
      }
    }
  }

  void updateUnits() {
    if (_unitsTC.text.isNotEmpty) {
      units = _unitsTC.text;
      data.units = units;
      data.update();
      setState(() {});
    }
  }

  void deleteGoal() async {
    setState(() {
      isLoading = true;
    });
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.goalsDelete(data.id, data.uuid);
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
                title: 'Delete Goal',
                content: Text('Are you sure you want to delete this goal?'),
                button1: 'Delete',
                button1Action: deleteGoal,
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
                      'Progress: ${data.completed} ${data.units}',
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
                          'Goal: ',
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
                  if (data.style != GoalsStyle.Completion)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Text(
                            'Units: ',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              onEditingComplete: updateUnits,
                              controller: _unitsTC,
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
                  if (data.style != GoalsStyle.Completion)
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
                ],
              ),
            ),
    );
  }
}
