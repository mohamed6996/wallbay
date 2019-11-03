import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_list.dart';

import '../constants.dart';

class FavoritesTab extends StatelessWidget {
  final _meMemoizer = AsyncMemoizer();

  FavoritesTab(Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoriteProvider favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    final PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Favorits')),
      body: preferencesProvider.isLogedIn == true
          ? FutureBuilder(
              future: _fetchMe(),
              builder: (context, userNameSnapshot) {
                switch (userNameSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (userNameSnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${userNameSnapshot.error}"));
                    } else {
                      return FutureBuilder(
                          future: favoriteProvider
                              .fetchData(userNameSnapshot.data.username),
                          builder: (context,
                              AsyncSnapshot<List<PhotoModel>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                                break;
                              default:
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text("Error: ${snapshot.error}"));
                                } else {
                                  return Consumer<FavoriteProvider>(
                                      builder: (context, provider, child) {
                                    return ImageList(
                                      models: favoriteProvider.photoModelList,
                                      isFavoriteTab: true,
                                    );
                                  });
                                }
                            }
                          });
                    }
                }
              })
          : Center(
              child: _login(context),
            ),
    );
  }

  _fetchMe() async {
    return _meMemoizer.runOnce(() async {
      return await repository.getMe();
    });
  }

  Widget _login(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'In order to like and download your favorite photos, you have to sign up first.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(padding: EdgeInsets.all(12)),
        Center(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 50),
          onPressed: () => _launchURL(),
          child: Text('Sign up or log in'),
          color: Colors.green,
          textColor: Colors.white,
        ))
      ],
    );
  }

  _launchURL() async {
    var loginUrl =constants.loginUrl;
    if (await canLaunch(loginUrl)) {
      await launch(loginUrl);
    } else {
      throw 'Could not launch $loginUrl';
    }
  }
}
