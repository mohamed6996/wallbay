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
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallbay'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: DataSearch(sharedPreferences));
            },
            tooltip: 'Search',
            icon: new Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder(
          future: _fetchData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: SpinKitHourGlass(
                  color: Colors.deepOrange,
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
          }),
    );
  }

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return PhotoRepository(sharedPreferences).fetchPhotos(1);
    });
  }
}

class DataSearch extends SearchDelegate<String> {
  final SharedPreferences sharedPreferences;

  DataSearch(this.sharedPreferences);

  _fetchData() async {
    return PhotoRepository(sharedPreferences).searchPhotos(1, query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: theme.primaryTextTheme.title.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: theme.primaryTextTheme.title.color)));
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isEmpty == true
        ? Container()
        : FutureBuilder(
            future: _fetchData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: SpinKitHourGlass(
                    color: Colors.deepOrange,
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
                      isSearch: true,
                      query: query,
                    );
                  }
              }
            });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
