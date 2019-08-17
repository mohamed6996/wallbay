import 'package:flutter/material.dart';
import 'package:wallbay/screens/home.dart';


void main() {
  return runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      accentColor: Colors.yellow[700],
      primaryColor: Colors.blueGrey[800],
    ),
    title: 'Wallbay',
    debugShowCheckedModeBanner: false,
    home: Home(), //Home()
  ));
}

//  https://www.youtube.com/watch?v=2W7POjFb88g&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG&index=44