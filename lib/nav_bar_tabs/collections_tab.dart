import 'package:flutter/material.dart';

class CollectionsTab extends StatefulWidget {
  CollectionsTab({Key key}) : super(key: key);

  @override
  CollectionsTabState createState() => CollectionsTabState();
}

class CollectionsTabState extends State<CollectionsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 250.0,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(10.0),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(5.0),
          color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
          child: Center(
            child: Text(index.toString()),
          ),
        ),
      ),
    );
  }
}
