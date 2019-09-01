import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _preferences;

  static Future<SharedPreferences> getPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
      return _preferences;
    }
    return _preferences;
  }




  //Choose Layout methods
 static saveLayout(int layout) {
    _preferences.setInt('layout', layout);
  }

 static int loadSavedLayout() {
    return _preferences.getInt('layout');
  }





  //Choose Collection methods
  static saveCollection(int collection) {
    _preferences.setInt('collection', collection);
  }

  static int loadSavedCollection() {
    return _preferences.getInt('collection');
  }
}
