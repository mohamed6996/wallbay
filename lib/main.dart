import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/home.dart';

import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PhotoRepository.create();
  return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => PreferencesProvider())
      ],
      child: MaterialApp(
        // theme: ThemeData(
        //   primarySwatch: Colors.blueGrey,
        //   accentColor: Colors.yellow[700],
        //   primaryColor: Colors.blueGrey[800],
        // ),
        theme: buildThemeData(),
        title: 'Wallbay',
        debugShowCheckedModeBanner: false,
        home: Home(),
      )));
}

ThemeData buildThemeData() {
  final baseTheme = ThemeData.dark();

  return baseTheme.copyWith(
    // primaryColor: kPrimaryColor,
    // primaryColorDark: kPrimaryDark,
    // primaryColorLight: kPrimaryLight,
    accentColor: Colors.greenAccent,
   // bottomAppBarColor: kSecondaryDark,
  //  buttonColor: kSecondaryColor,
    bottomAppBarColor: Colors.black,

  );
}
