import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:new_life/helpers/database_helper.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitCalendar extends StatefulWidget {
  final HabitData data;
  final Function downSet;

  HabitCalendar({@required this.data, @required this.downSet});
  @override
  _HabitCalendarState createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  CalendarController _calendarController;
  Map<DateTime, List> _events = {};
  List _selEvents = [];
  DateTime _selDay;
  final pattern = 'MMM dd, yyyy - h:mm:ss a';
  String typeStr = '';

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    widget.data.trackingList.forEach((element) {
      DateTime newDT = DateTime(
        element.trackDT.year,
        element.trackDT.month,
        element.trackDT.day,
      );
      if ((_events[newDT] == null) || (_events[newDT].isEmpty)) {
        _events[newDT] = [element.trackDT];
      } else {
        _events[newDT].add(element.trackDT);
      }
    });
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    _selEvents = _events[today] ?? [];
    _selDay = DateTime.now();
    typeStr = widget.data.type.toString().split('.').last.toLowerCase() + 's';
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selEvents = events;
      _selDay = day;
    });
  }

  void _deleteTrakingLog(DateTime fullDt) async {
    DateTime realDt = DateTime(
      fullDt.year,
      fullDt.month,
      fullDt.day,
    );
    final dbHelper = DatabaseHelper.instance;
    if (widget.data.type == HabitType.Day) {
      if (realDt.isToday) {
        widget.data.setCompleted(widget.data.completed - 1);
        widget.data.update();
      }
    } else if (widget.data.type == HabitType.Week) {
      if (realDt.isBefore(DateTime.now().startOfWeek)) {
        widget.data.setCompleted(widget.data.completed - 1);
        widget.data.update();
      }
    } else if (widget.data.type == HabitType.Month) {
      if (realDt.isThisMonth) {
        widget.data.setCompleted(widget.data.completed - 1);
        widget.data.update();
      }
    }
    await dbHelper.trackDelete(widget.data.uuid, fullDt.toIso8601String());
    _events[realDt].remove(fullDt);
    widget.downSet();
  }

  void _addTrakingLog(DateTime timeDt) async {
    DateTime fullDt = DateTime(
      _selDay.year,
      _selDay.month,
      _selDay.day,
      timeDt.hour,
      timeDt.minute,
      timeDt.second,
    );
    DateTime realDt = DateTime(
      _selDay.year,
      _selDay.month,
      _selDay.day,
    );
    final dbHelper = DatabaseHelper.instance;
    if (widget.data.type == HabitType.Day) {
      if (fullDt.isToday) {
        widget.data.setCompleted(widget.data.completed + 1);
        widget.data.update();
      }
    } else if (widget.data.type == HabitType.Week) {
      if (fullDt.isAfter(DateTime.now().startOfWeek)) {
        widget.data.setCompleted(widget.data.completed + 1);
        widget.data.update();
      }
    } else if (widget.data.type == HabitType.Month) {
      if (fullDt.isThisMonth) {
        widget.data.setCompleted(widget.data.completed + 1);
        widget.data.update();
      }
    }

    Map<String, dynamic> row = {
      DatabaseHelper.columnUuid: widget.data.uuid,
      DatabaseHelper.columnTrackDate: fullDt.toIso8601String(),
    };
    await dbHelper.trackInsert(row);
    if ((_events[realDt] == null) || (_events[realDt].isEmpty)) {
      _events[realDt] = [fullDt];
      _selEvents = [fullDt];
    } else {
      _events[realDt].add(fullDt);
      _selEvents.add(fullDt);
    }
    widget.downSet();
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      availableCalendarFormats: {CalendarFormat.month: 'Month'},
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarController: _calendarController,
      events: _events,
      onDaySelected: (date, events, _) {
        _onDaySelected(date, events);
      },
      calendarStyle: CalendarStyle(
        selectedColor: widget.data.catColor,
        weekendStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        outsideWeekendStyle: TextStyle(
          color: Colors.grey[700],
          fontSize: 20.0,
        ),
        outsideStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: widget.data.catColor,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: widget.data.catColor,
              ),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, _) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Container(
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(
                      fontSize: 20.0,
                      color: date.isThisMonth ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          } else {
            children.add(
              Container(
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(
                      fontSize: 20.0,
                      color: date.isThisMonth ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }
          return children;
        },
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.data.catColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackEvents() {
    ListView lv = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, i) {
        DateTime dt = _selEvents[i];
        String dateStr = dt.format(pattern);
        return Dismissible(
          key: ValueKey(_selEvents[i]),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.centerRight,
            color: Color(0xd0b71c1c),
            child: Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(''),
                ),
                IconButton(
                  color: Color(0xf0b71c1c),
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _deleteTrakingLog(dt);
                  },
                ),
              ],
            ),
          ),
          onDismissed: (_) {
            _deleteTrakingLog(dt);
          },
        );
      },
      itemCount: _selEvents.length,
    );
    return Container(
      height: (_selEvents.length * 50).toDouble(),
      child: lv,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableCalendar(),
        if (!_selDay.isFuture)
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black,
          ),
        if (!_selDay.isFuture)
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  'Tracking Log: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  _selDay.format('MMM dd, yyyy'),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(''),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    size: 30.0,
                  ),
                  onPressed: () {
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        _addTrakingLog(date);
                      },
                      currentTime: DateTime.now(),
                      theme: DatePickerTheme(
                        containerHeight: 300.0,
                        itemStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        cancelStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                        doneStyle: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                  },
                  color: widget.data.catColor,
                ),
              ],
            ),
          ),
        if (!_selDay.isFuture)
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black,
          ),
        if ((_selEvents.length > 0) && (!_selDay.isFuture)) _buildTrackEvents(),
        if (!_selDay.isFuture)
          SizedBox(
            height: 5,
          ),
        if (!_selDay.isFuture)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Please note: Changing tracking logs for prior $typeStr will not impact your current or longest streak.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (!_selDay.isFuture)
          SizedBox(
            height: 5,
          ),
        if (!_selDay.isFuture)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
          ),
      ],
    );
  }
}
