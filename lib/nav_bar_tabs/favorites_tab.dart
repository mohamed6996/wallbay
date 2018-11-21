import 'package:flutter/material.dart';

class FavoritesTab extends StatefulWidget {
  FavoritesTab({Key key}) : super(key: key);

  @override
  FavoritesTabState createState() => FavoritesTabState();
}

class FavoritesTabState extends State<FavoritesTab> {
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
