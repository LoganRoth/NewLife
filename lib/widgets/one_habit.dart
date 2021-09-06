import 'package:flutter/material.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/models/track_data.dart';
import 'package:new_life/screens/habit_detail_screen.dart';

class OneHabit extends StatefulWidget {
  final HabitData data;
  final Key key;
  final Function update;

  OneHabit({
    @required this.data,
    @required this.key,
    @required this.update,
  });
  @override
  _OneHabitState createState() => _OneHabitState();
}

class _OneHabitState extends State<OneHabit> {
  final dbHelper = DatabaseHelper.instance;

  void addPoint() {
    setState(() {
      widget.data.addPoint(dbHelper);
    });
  }

  void subtractPoint() {
    setState(() {
      widget.data.subtractPoint(dbHelper);
    });
  }

  void goToDetail() async {
    List<Map<String, dynamic>> tdList =
        await dbHelper.trackQueryAllRows(widget.data.uuid);
    List<TrackData> td = [];
    tdList.forEach((element) {
      td.add(
        TrackData(
          element[DatabaseHelper.columnId],
          uuid: element[DatabaseHelper.columnUuid],
          trackDT: DateTime.parse(
            element[DatabaseHelper.columnTrackDate],
          ),
        ),
      );
    });
    widget.data.trackingList = td;
    await Navigator.of(context)
        .pushNamed(DetailHabitScreen.routeName, arguments: widget.data);
    widget.update();
  }

  @override
  Widget build(BuildContext context) {
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
        onTap: addPoint,
        onDoubleTap: subtractPoint,
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
                          Icons.whatshot,
                          color: widget.data.isComplete
                              ? Colors.orange
                              : Colors.white,
                          size: widget.data.isComplete
                              ? MediaQuery.of(context).size.height * 0.04
                              : MediaQuery.of(context).size.height * 0.03,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${widget.data.streak}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
                          Text(
                            "${widget.data.completed}/${widget.data.toComplete}",
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
