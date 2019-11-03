import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class PreferencesProvider extends ChangeNotifier {
  SharedPreferences _sharedPreferences;

  SharedPreferences get sharedPrefs => _sharedPreferences;

  int get layoutType => _sharedPreferences.getInt('layout') ?? 0;

  set layoutType(int type) => _sharedPreferences.setInt('layout', type);

  int get collectionType => _sharedPreferences.getInt('collection') ?? 0;

  bool get isLogedIn =>
      _sharedPreferences.getBool(Constants.OAUTH_LOGED_IN) ?? false;

  String get loadQuality => _sharedPreferences.getString('loadQuality') ?? 'Regular';
  String get downloadQuality => _sharedPreferences.getString('downloadQuality')?? 'Full';

  set isLogedIn(bool islogedin) {
    _sharedPreferences.setBool(Constants.OAUTH_LOGED_IN, islogedin);
    notifyListeners();
  }

  set accessToken(String token) {
    _sharedPreferences.setString(Constants.OAUTH_ACCESS_TOKEN, token);
  }

  set accessTokenType(String tokenType) {
    _sharedPreferences.setString(Constants.OAUTH_TOKEN_TYPE, tokenType);
  }

  set collectionType(int type) {
    _sharedPreferences.setInt('collection', type);
    notifyListeners();
  }

  set loadQuality(String quality) {
    _sharedPreferences.setString('loadQuality', quality);
  }

  set downloadQuality(String quality) {
    _sharedPreferences.setString('downloadQuality', quality);
  }

  Future<SharedPreferences> initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }
}
