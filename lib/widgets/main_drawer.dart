import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final Function changePageFunc;
  MainDrawer({this.changePageFunc});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(
                  Icons.book,
                  color: Colors.green,
                ),
                title: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  changePageFunc('Overview');
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
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
                  changePageFunc('Habits');
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
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
                  changePageFunc('Goals');
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                title: Text(
                  'Ad Free',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onTap: () {
                  print('Ad Free');
                },
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
