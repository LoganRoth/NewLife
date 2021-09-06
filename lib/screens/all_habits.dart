import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_life/models/habit_data.dart';
import 'package:new_life/widgets/one_habit.dart';

class AllHabits extends StatelessWidget {
  final List<List<HabitData>> dataSets;
  final Function refreshFunc;

  AllHabits({
    @required this.dataSets,
    @required this.refreshFunc,
  });

  List<Widget> buildLists() {
    List<Widget> allWidgets = [];
    dataSets.forEach((dataSet) {
      if (dataSet.isNotEmpty) {
        allWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 25.0, bottom: 5.0),
            child: Text(
              dataSet[0].type.toString().split('.').last,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        );
        dataSet.forEach((oneData) {
          allWidgets.add(
            OneHabit(
              data: oneData,
              key: ValueKey(oneData.uuid),
              update: refreshFunc,
            ),
          );
        });
      }
    });
    return allWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.90,
        child: dataSets.isEmpty ||
                (dataSets[0].isEmpty &&
                    dataSets[1].isEmpty &&
                    dataSets[2].isEmpty)
            ? Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'Create your first Habit!',
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
                onRefresh: refreshFunc,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildLists(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
