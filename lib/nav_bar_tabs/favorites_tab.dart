import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/me_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_list.dart';

class FavoritesTab extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final bool isLogedin;
  final _meMemoizer = AsyncMemoizer();
  final _memoizer = AsyncMemoizer();

  FavoritesTab(Key key, this.sharedPreferences, {this.isLogedin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorits')),
      body: isLogedin == true
          ? FutureBuilder(
              future: _fetchMe(),
              builder: (context, userNameSnapshot) {
                switch (userNameSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: SpinKitHourGlass(
                      color: Colors.purple,
                    ));
                    break;
                  default:
                    if (userNameSnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${userNameSnapshot.error}"));
                    } else {
                      return FutureBuilder(
                          future: _fetchData(userNameSnapshot.data.username),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: SpinKitHourGlass(
                                  color: Colors.purple,
                                ));
                                break;
                              default:
                                if (snapshot.hasData) {
                                  return ImageList(
                                    models: snapshot.data,
                                    sharedPreferences: sharedPreferences,
                                    isFavoriteTab: true,
                                    userName: userNameSnapshot.data.username,
                                  );
                                } else {
                                  return Center(
                                      child: Text("Error: ${snapshot.error}"));
                                }
                            }
                          });
                    }
                }
              })
          : Center(
              child: Text('You must login first'),
            ),
    );
  }

  _fetchMe() async {
    return _meMemoizer.runOnce(() async {
      return await PhotoRepository(sharedPreferences).getMe();
    });
  }

  _fetchData(String userName) async {
    return _memoizer.runOnce(() async {
      return PhotoRepository(sharedPreferences)
          .fetchFavoritePhotos(1, userName);
    });
  }
}
