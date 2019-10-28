import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/collection_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/widgets/collection_card.dart';

class CollectionList extends StatefulWidget {
  final List<CollectionModel> models;
  final bool userCollection;

  CollectionList({
    Key key,
    this.models,
    this.userCollection = false,
  }) : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  List<CollectionModel> models;

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  int currentPage = 1;

  CollectionProvider _collectionProvider;
  PreferencesProvider _preferencesProvider;

  @override
  void initState() {
    this.models = widget.models;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreData();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    _preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);

    return _buildListView(_scrollController);
  }

  Widget _buildListView(ScrollController scrollController) {
    return Container(
        child: ListView.builder(
            scrollDirection:
                widget.userCollection ? Axis.horizontal : Axis.vertical,
            controller: scrollController,
            itemCount: models.length + 1,
            itemBuilder: (context, int index) {
              if (index == models.length) {
                return SpinKitThreeBounce(
                  color: Colors.greenAccent,
                  size: 30.0,
                );
              } else {
                return CollectionCard(models[index], widget.userCollection);
              }
            }));
  }

  void _fetchMoreData() async {
    models = await _collectionProvider
        .fetchMoreData(_preferencesProvider.collectionType);
  }
}
