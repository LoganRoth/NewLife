import 'package:flutter/material.dart';
import 'package:new_life/widgets/main_drawer.dart';

class OverviewPage extends StatefulWidget {
  final Function changePageFunc;
  OverviewPage({this.changePageFunc});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Widget buildOverviewScreen() {
    Color myCol = Color(0xff252525);
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 10,
              color: myCol,
              child: Container(
                height: 75,
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.whatshot,
                      color: Colors.orange,
                    ),
                    title: Text(
                      'Habits',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      widget.changePageFunc('Habits');
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              color: myCol,
              child: Container(
                height: 75,
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_events,
                      color: Color(0xffffd700),
                    ),
                    title: Text(
                      'Goals',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      widget.changePageFunc('Goals');
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Card(
              elevation: 10,
              color: Colors.blue[800],
              child: Container(
                height: 75,
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    title: Text(
                      'Ad Free',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: myCol,
                      ),
                    ),
                    onTap: () {
                      print('Ad Free');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Life',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ),
      drawer: MainDrawer(
        changePageFunc: widget.changePageFunc,
      ),
      body: buildOverviewScreen(),
    );
  }
}
