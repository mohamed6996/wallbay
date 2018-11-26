import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/widgets/image_list.dart';

class MainFeedTab extends StatelessWidget {
  final _memoizer = AsyncMemoizer();
  final SharedPreferences sharedPreferences;

  MainFeedTab(Key key, this.sharedPreferences) : super(key: key);

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
                return ImageList(
                  models: snapshot.data,
                  sharedPreferences: sharedPreferences,
                  isFavoriteTab: false,
                );
              }
          }
        });
  }

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return PhotoRepository(sharedPreferences).fetchPhotos(1);
    });
  }
}