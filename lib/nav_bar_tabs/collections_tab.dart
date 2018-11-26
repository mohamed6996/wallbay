import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/widgets/collection_list.dart';

class CollectionsTab extends StatelessWidget {
  final _memoizer = AsyncMemoizer();
  final SharedPreferences sharedPreferences;

  CollectionsTab(Key key, this.sharedPreferences) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: SpinKitHourGlass(
                    color: Colors.purple,
                  ));
              break;
            default:
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return CollectionList(
                  models: snapshot.data,sharedPreferences: sharedPreferences
                );
              }
          }
        });
  }

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return PhotoRepository(sharedPreferences).fetchCollections(1);
    });
  }
}
