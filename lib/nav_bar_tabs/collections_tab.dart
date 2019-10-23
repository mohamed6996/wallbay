import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/widgets/collection_list.dart';

typedef onCollectionSelected = void Function(String filter);

class CollectionsTab extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  CollectionsTab(Key key, this.sharedPreferences) : super(key: key);

  @override
  _CollectionsTabState createState() => _CollectionsTabState();
}

class _CollectionsTabState extends State<CollectionsTab> {
  final _allMemoizer = AsyncMemoizer();
  final _wallpaperMemoizer = AsyncMemoizer();

  int filter;

  @override
  void initState() {
    super.initState();
    // filter = widget.sharedPreferences.getInt('collection') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilterCollection((value) {
                setState(() {
                  if (value == "All") {
                    this.filter = 0;
                    widget.sharedPreferences.setInt('collection', 0);
                  } else {
                    widget.sharedPreferences.setInt('collection', 1);
                    this.filter = 1;
                  }
                });
              }),
            ),
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
                      color: Colors.purple,
                    ));
                break;
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return CollectionList(
                    models: snapshot.data,
                    sharedPreferences: widget.sharedPreferences,
                    isWallpaper: filter == 1 ? true : false,
                  );
                }
            }
          }),
    );
  }

  _fetchData() async {
    if (filter == 0) {
      return _allMemoizer.runOnce(() async {
        return PhotoRepository(widget.sharedPreferences).fetchCollections(1);
      });
    } else {
      return _wallpaperMemoizer.runOnce(() async {
        return PhotoRepository(widget.sharedPreferences).searchCollections(1);
      });
    }
  }
}

class FilterCollection extends StatefulWidget {
  final onCollectionSelected _collectionSelected;

  FilterCollection(this._collectionSelected);

  @override
  _FilterCollectionState createState() => _FilterCollectionState();
}

class _FilterCollectionState extends State<FilterCollection> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        iconEnabledColor: Colors.white,
        underline: Container(),
        isExpanded: false,
        isDense: true,
        hint: null,
        icon: Icon(Icons.filter_list, color: Colors.white),
        items: [
          DropdownMenuItem(
            value: 'All',
            child: Row(
              children: <Widget>[
                Icon(Icons.apps),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                Text('All'),
              ],
            ),
          ),
          DropdownMenuItem(
              value: 'Wallpaper',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.wallpaper),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  Text('Wallpaper'),
                ],
              )),
        ],
        onChanged: widget._collectionSelected);
  }
}
