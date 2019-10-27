import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_list.dart';

class FavoritesTab extends StatelessWidget {
  final bool isLogedin;
  final _meMemoizer = AsyncMemoizer();

  FavoritesTab(Key key, {this.isLogedin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoriteProvider favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

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
                          future: favoriteProvider.fetchData( userNameSnapshot.data.username),
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
              child: Text('You must login first'),
            ),
    );
  }

  _fetchMe() async {
    return _meMemoizer.runOnce(() async {
      return await repository.getMe();
    });
  }

}
