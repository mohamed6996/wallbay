import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import 'bloc/coll_photos_provider.dart';
import 'bloc/user_details_provider.dart';

SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await intit();
  await initSharedPref();
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
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            theme: provider.theme == 0 ? darkTheme : lightTheme,
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

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Color(0xFF000000),
  accentColor: Colors.blueAccent,
  toggleableActiveColor: Colors.blueAccent,
  dividerColor: Colors.black54,
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: Color(0xFFE5E5E5),
  accentColor: Colors.blueAccent,
  toggleableActiveColor: Colors.blueAccent,
  dividerColor: Colors.white54,
);
