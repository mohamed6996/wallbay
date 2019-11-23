import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';


class PreferencesProvider extends ChangeNotifier {

  int get layoutType => sharedPreferences.getInt('layout') ?? 0;

  set layoutType(int type) => sharedPreferences.setInt('layout', type);

  int get collectionType => sharedPreferences.getInt('collection') ?? 0;

  bool get isLogedIn =>
      sharedPreferences.getBool(Constants.OAUTH_LOGED_IN) ?? false;

  String get loadQuality =>
      sharedPreferences.getString('loadQuality') ?? 'Regular';
  String get downloadQuality =>
      sharedPreferences.getString('downloadQuality') ?? 'Full';

  int get theme => sharedPreferences.getInt('theme') ?? 0;
  set theme(int theme) {
    sharedPreferences.setInt('theme', theme);
    notifyListeners();
  }

  set isLogedIn(bool islogedin) {
    sharedPreferences.setBool(Constants.OAUTH_LOGED_IN, islogedin);
    notifyListeners();
  }

  set accessToken(String token) {
    sharedPreferences.setString(Constants.OAUTH_ACCESS_TOKEN, token);
  }

  set accessTokenType(String tokenType) {
    sharedPreferences.setString(Constants.OAUTH_TOKEN_TYPE, tokenType);
  }

  set collectionType(int type) {
    sharedPreferences.setInt('collection', type);
    notifyListeners();
  }

  set loadQuality(String quality) {
    sharedPreferences.setString('loadQuality', quality);
  }

  set downloadQuality(String quality) {
    sharedPreferences.setString('downloadQuality', quality);
  }

  
}
