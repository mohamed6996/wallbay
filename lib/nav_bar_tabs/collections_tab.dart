import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallbay/widgets/collection_list.dart';

typedef onCollectionSelected = void Function(String filter);

class CollectionsTab extends StatelessWidget {
  CollectionsTab(Key key) : super(key: key);
  final _allMemoizer = AsyncMemoizer();
  final _wallpaperMemoizer = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    PreferencesProvider mainProvider = Provider.of<PreferencesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilterCollection((value) {
                if (value == "All") {
                  mainProvider.collectionType = 0;
                } else {
                  mainProvider.collectionType = 1;
                }
              }),
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: _fetchData(mainProvider),
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
                    isWallpaper: mainProvider.collectionType == 1 ? true : false,
                  );
                }
            }
          }),
    );
  }

  _fetchData(PreferencesProvider mainProvider) async {
    if (mainProvider.collectionType == 0) {
      return _allMemoizer.runOnce(() async {
        return await repository.fetchCollections(1);
      });
    } else {
      return _wallpaperMemoizer.runOnce(() async {
        return repository.searchCollections(1);
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
