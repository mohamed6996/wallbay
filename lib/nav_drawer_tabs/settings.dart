import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20.0)),
            Text("Settings Page"),
            Padding(padding: EdgeInsets.all(20.0)),
            Icon(
              Icons.android,
              size: 90.0,
            ),
          ],
        ),
      ),
    );
  }
}