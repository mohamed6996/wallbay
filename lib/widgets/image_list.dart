import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/widgets/image_card.dart';

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;
  final SharedPreferences sharedPreferences;
  final isFavoriteTab;
  final String userName;

  ImageList(
      {Key key,
        this.models,
        this.sharedPreferences,
        this.isFavoriteTab,
        this.userName})
      : super(key: key);

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
            itemCount: models.length + 1,
            itemBuilder: (context, int index) {
              if (index == models.length) {
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
      List<PhotoModel> newModels;
      if (!widget.isFavoriteTab) {
        newModels = await _photoRepo.fetchPhotos(currentPage);
      } else {
        newModels =
        await _photoRepo.fetchFavoritePhotos(currentPage, widget.userName);
      }
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
