import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  SharedPreferences _sharedPreferences;

  SharedPreferences get sharedPrefs => _sharedPreferences;

  int get layoutType => _sharedPreferences.getInt('layout') ?? 0;

  set layoutType(int type) => _sharedPreferences.setInt('layout', type);

  int get collectionType => _sharedPreferences.getInt('collection') ?? 0;

  set collectionType(int type) {
    _sharedPreferences.setInt('collection', type);
    notifyListeners();
  }

  Future<SharedPreferences> initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
   
  }
}
