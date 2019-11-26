import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("table page"),
      ),
      body: Column(
        children: <Widget>[
          Table(
            children: [
              TableRow(children: [
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell")),
                TableCell(child: Text("table cell"))
              ], decoration: BoxDecoration(color: Colors.black12, border: Border.all(color: Colors.red)))
            ],
            border: TableBorder.all(color: Colors.blue),
          )
        ],
      ),
    );
  }
}
