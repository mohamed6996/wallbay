import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/bloc/collection_provider.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/bloc/search_provider.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/home.dart';
import 'package:wallbay/utils/connectivity_service.dart';

import 'bloc/coll_photos_provider.dart';
import 'bloc/user_details_provider.dart';

SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await intit();
  await initSharedPref();
  await PhotoRepository.create();
  //ConnectivityService();

  return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => PreferencesProvider()),
        ChangeNotifierProvider(builder: (_) => MainProvider()),
        ChangeNotifierProvider(builder: (_) => FavoriteProvider()),
        ChangeNotifierProvider(builder: (_) => CollectionProvider()),
        ChangeNotifierProvider(builder: (_) => CollPhotosProvider()),
        ChangeNotifierProvider(builder: (_) => SearchProvider()),
        ChangeNotifierProvider(builder: (_) => UserDetailsProvider()),
        //ChangeNotifierProvider(builder: (_) => ConnectivityService()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            theme: provider.theme == 0 ? _buildDarkTheme() : _buildLightTheme(),
            title: 'Wallbay',
            home: child,
          );
        },
        child: Home(),
      )));
}

intit() async {
  var map = await Constants.create();
  constants.clientId = map['clientId'].replaceAll(RegExp(r'[^\w\s]+'), '');
  constants.clientSecret =
      map['clientSecret'].replaceAll(RegExp(r'[^\w\s]+'), '');
  constants.loginUrl = map['clientId'].replaceAll(RegExp(r'[^\w\s]+'), '');
}

initSharedPref() async {
  sharedPreferences = await SharedPreferences.getInstance();
}

ThemeData _buildDarkTheme() {
  return ThemeData.dark().copyWith(
    accentColor: Colors.blueAccent,
    toggleableActiveColor: Colors.blueAccent,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
          title: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              fontFamily: 'Lobster')),
    ),
  );
}

ThemeData _buildLightTheme() {
  return ThemeData.light().copyWith(
    primaryColor: Colors.white,
    primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
    primaryIconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: TextTheme(
          title: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              fontFamily: 'Lobster')),
    ),
    accentColor: Colors.blueAccent,
    toggleableActiveColor: Colors.blueAccent,
  );
}
