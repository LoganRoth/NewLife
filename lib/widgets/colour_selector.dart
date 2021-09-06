import 'package:flutter/material.dart';

class ColourSelector extends StatefulWidget {
  final Function colourSet;

  ColourSelector({
    @required this.colourSet,
  });

  @override
  _ColourSelectorState createState() => _ColourSelectorState();
}

class _ColourSelectorState extends State<ColourSelector> {
  Container colourButton(Color colour) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1,
      child: RaisedButton(
        shape: CircleBorder(),
        color: colour,
        onPressed: () => widget.colourSet(colour),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              colourButton(Colors.red[900]),
              colourButton(Colors.green[900]),
              colourButton(Colors.indigo[800]),
              colourButton(Colors.lime[800]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              colourButton(Colors.purple[900]),
              colourButton(Colors.cyan[900]),
              colourButton(Colors.pink),
              colourButton(Colors.teal),
            ],
          )
        ],
      ),
    );
  }
}
