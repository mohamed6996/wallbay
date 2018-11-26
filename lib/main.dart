import 'package:flutter/material.dart';
import 'package:wallbay/screens/home.dart';

void main() {
  return runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    title: 'Wallbay',
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

