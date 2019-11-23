import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/collection_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/widgets/collection_list.dart';

typedef onCollectionSelected = void Function(String filter);

class CollectionsTab extends StatelessWidget {
  CollectionsTab(Key key) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    CollectionProvider collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilterCollection((value) {
                if (value == "All") {
                  preferencesProvider.collectionType = 0;
                } else {
                  preferencesProvider.collectionType = 1;
                }
              }),
            ),
          )
        ],
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, prefs, child) {
          return FutureBuilder(
              future: prefs.collectionType == 0
                  ? collectionProvider.fetchData()
                  : collectionProvider.fetchWallPaper(),
              builder:
                  (context, AsyncSnapshot<List<CollectionModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text("Check your internet connection!"));
                    } else {
                      return Consumer<CollectionProvider>(
                          builder: (context, provider, child) {
                        return CollectionList(
                          models: snapshot.data,
                        );
                      });
                    }
                }
              });
        },
      ),
    );
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
        // iconEnabledColor: Colors.white,
        underline: Container(),
        isExpanded: false,
        isDense: true,
        hint: null,
        icon: Icon(Icons.filter_list),
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
