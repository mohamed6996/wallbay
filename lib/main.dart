import 'package:flutter/material.dart';
import 'package:wallbay/screens/home.dart';

import 'nav_bar_tabs/settings_tab.dart';

void main() {
  return runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      accentColor: Colors.yellow[700],
      primaryColor: Colors.blueGrey[800],
    ),
    title: 'Wallbay',
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}
