import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/bloc/search_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/widgets/image_list.dart';

class MainFeedTab extends StatelessWidget {
  MainFeedTab(Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallbay'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(),);
            },
            tooltip: 'Search',
            icon: new Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder(
          future: mainProvider.fetchData(),
          builder: (context, AsyncSnapshot<List<PhotoModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return Consumer<MainProvider>(
                      builder: (context, provider, child) {
                    return ImageList(
                      models: mainProvider.photoModelList,
                      isFavoriteTab: false,
                    );
                  });
                }
            }
          }),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  
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
    return query.isEmpty == true ? Container() : SearchWidget(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class SearchWidget extends StatefulWidget {
  final String query;
  SearchWidget(this.query);
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with AutomaticKeepAliveClientMixin {
  Future _future;
  @override
  void initState() {
    super.initState();
    SearchProvider searchProvider =
        Provider.of<SearchProvider>(context, listen: false);
    _future = searchProvider.fetchData(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: SpinKitHourGlass(
                color: Colors.greenAccent,
              ));
              break;
            default:
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return Consumer<SearchProvider>(
                  builder: (context, provider, child) => ImageList(
                    models: snapshot.data,
                    isSearch: true,
                  ),
                );
              }
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
