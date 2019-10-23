import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_list.dart';

class FavoritesTab extends StatelessWidget {
  final bool isLogedin;
  final _meMemoizer = AsyncMemoizer();
  final _memoizer = AsyncMemoizer();

  FavoritesTab(Key key, {this.isLogedin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreferencesProvider mainProvider =
        Provider.of<PreferencesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Favorits')),
      body: isLogedin == true
          ? FutureBuilder(
              future: _fetchMe(mainProvider.sharedPrefs),
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
                          future: _fetchData(userNameSnapshot.data.username,mainProvider.sharedPrefs),
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

  _fetchMe(SharedPreferences prefs) async {
    return _meMemoizer.runOnce(() async {
      return await repository.getMe();
    });
  }

  _fetchData(String userName, SharedPreferences prefs) async {
    return _memoizer.runOnce(() async {
      return repository.fetchFavoritePhotos(1, userName);
    });
  }
}
