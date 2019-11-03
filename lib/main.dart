import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/collection_provider.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/bloc/search_provider.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/home.dart';

import 'bloc/coll_photos_provider.dart';
import 'bloc/user_details_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await intit();
  await PhotoRepository.create();

  return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => PreferencesProvider()),
        ChangeNotifierProvider(builder: (_) => MainProvider()),
        ChangeNotifierProvider(builder: (_) => FavoriteProvider()),
        ChangeNotifierProvider(builder: (_) => CollectionProvider()),
        ChangeNotifierProvider(builder: (_) => CollPhotosProvider()),
        ChangeNotifierProvider(builder: (_) => SearchProvider()),
        ChangeNotifierProvider(builder: (_) => UserDetailsProvider()),
      ],
      child: MaterialApp(
        theme: buildThemeData(),
        title: 'Wallbay',
        debugShowCheckedModeBanner: false,
        home: Home(),
      )));
}

intit() async {
  var map = await  Constants.create();
  constants.clientId = map['clientId'].replaceAll( RegExp(r'[^\w\s]+'),'');
  constants.clientSecret = map['clientSecret'].replaceAll( RegExp(r'[^\w\s]+'),'');
  constants.loginUrl = map['clientId'].replaceAll( RegExp(r'[^\w\s]+'),'');
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
