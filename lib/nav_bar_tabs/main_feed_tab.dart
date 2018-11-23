import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/widgets/image_card.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class MainFeedTab extends StatelessWidget {
  final _memoizer = AsyncMemoizer();
  final SharedPreferences sharedPreferences;

  MainFeedTab(Key key, this.sharedPreferences) : super(key: key);

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
                return ImageList(
                  models: snapshot.data,
                  sharedPreferences: sharedPreferences,
                );
              }
          }
        });
  }

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return PhotoRepository(sharedPreferences).fetchPhotos(1);
    });
  }
}

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;
  final SharedPreferences sharedPreferences;

  ImageList({Key key, this.models, this.sharedPreferences}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<PhotoModel> models;
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
      List<PhotoModel> models, ScrollController scrollController) {
    return Container(
        child: ListView.builder(
            controller: scrollController,
            itemCount: models.length,
            itemBuilder: (context, int index) {
              if (index == models.length - 1) {
                print(models[index].liked_by_user);
                return SpinKitThreeBounce(
                  color: Colors.purple,
                  size: 30.0,
                );
              } else {
                return ImageCard(
                  models[index],
                  () => onFavoritePressed(index),
                );
              }
            }));
  }

  onFavoritePressed(int index) async {
    final model = models[index];
    String photoId = model.photoId;

    if (!model.liked_by_user) {
      _photoRepo.likePhoto(photoId).then((_) {
        setState(() {
          model.liked_by_user = true;
        });
      });
    } else {
      _photoRepo.unlikePhoto(photoId).then((_) {
        setState(() {
          model.liked_by_user = false;
        });
      });
    }
  }

  void _fetchMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
        currentPage++;
      });
      List<PhotoModel> newModels = await _photoRepo.fetchPhotos(currentPage);
      setState(() {
        models.addAll(newModels);
        isPerformingRequest = false;
      });
    }
  }
}
