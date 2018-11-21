import 'package:flutter/material.dart';
import 'package:wallbay/widgets/image_card.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainFeedTab extends StatefulWidget {
  MainFeedTab({Key key}) : super(key: key);
  final _memoizer = AsyncMemoizer();

  @override
  MainFeedTabState createState() {
    return new MainFeedTabState();
  }
}

class MainFeedTabState extends State<MainFeedTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                return ImageList(models: snapshot.data);
              }
          }
        });
  }

  _fetchData() async {
    return widget._memoizer.runOnce(() async {
      return await PhotoRepository().fetchPhotos(1);
      // return 'REMOTE DATA';
    });
  }
}

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;

  ImageList({Key key, this.models}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<PhotoModel> models;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  int currentPage = 1;

  bool isLiked = false, isFollowing = false;

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
    return _buildListView(models, _scrollController);
  }

  Widget _buildListView(
      List<PhotoModel> models, ScrollController scrollController) {
    return Container(
        child: ListView.builder(
            controller: scrollController,
            itemCount: models.length,
            itemBuilder: (context, int index) {
              if (index == models.length - 1) {
                return _buildProgressIndicator();
              } else {
                return ImageCard(
                    models[index].regularPhotoUrl,
                    models[index].mediumProfilePhotoUrl,
                    models[index].name,
                    models[index].color);
              }
            }));
  }

  void _fetchMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
        currentPage++;
      });
      List<PhotoModel> newModels =
          await new PhotoRepository().fetchPhotos(currentPage);
      setState(() {
        models.addAll(newModels);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return SpinKitThreeBounce(
      color: Colors.purple,
      size: 30.0,
    );
  }
}
