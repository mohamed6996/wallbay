import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/collection_card.dart';

class CollectionList extends StatefulWidget {
  final List<CollectionModel> models;
  final SharedPreferences sharedPreferences;
  final bool userCollection;

  CollectionList(
      {Key key,
      this.models,
      this.sharedPreferences,
      this.userCollection = false})
      : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  List<CollectionModel> models;
  PhotoRepository _photoRepo;

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  int currentPage = 1;

  @override
  void initState() {
    this.models = widget.models;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreData();
      }
    });

    // initSharedPref();
    _photoRepo = new PhotoRepository(widget.sharedPreferences);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView(models, _scrollController);
  }

  Widget _buildListView(
      List<CollectionModel> models, ScrollController scrollController) {
    return Container(
        child: ListView.builder(
            scrollDirection:
                widget.userCollection ? Axis.horizontal : Axis.vertical,
            controller: scrollController,
            itemCount: models.length + 1,
            itemBuilder: (context, int index) {
              if (index == models.length) {
                return SpinKitThreeBounce(
                  color: Colors.purple,
                  size: 30.0,
                );
              } else {
                return CollectionCard(models[index],widget.userCollection);
              }
            }));
  }

  void _fetchMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
        currentPage++;
      });
      List<CollectionModel> newModels =
          await _photoRepo.fetchCollections(currentPage);
      // check if return data is empty
      if (newModels.isEmpty) {
        double edge = 30.0;
        double offSetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offSetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offSetFromBottom),
              duration: Duration(microseconds: 1000),
              curve: Curves.easeOut);
        }
      }

      setState(() {
        models.addAll(newModels);
        isPerformingRequest = false;
      });
    }
  }
}
