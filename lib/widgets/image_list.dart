import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/photo_details_screen.dart';
import 'package:wallbay/utils/shared_prefs.dart';
import 'package:wallbay/widgets/image_card.dart';

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;
  final SharedPreferences sharedPreferences;
  final isFavoriteTab;
  final bool isCollectionPhotos;
  final bool isSearch;
  final bool isPhotoUserProfile;
  final String query;
  final int collectionId;
  final String userName;

  ImageList(
      {Key key,
      this.models,
      this.sharedPreferences,
      this.isFavoriteTab,
      this.isCollectionPhotos = false,
      this.isSearch = false,
      this.isPhotoUserProfile = false,
      this.query = '',
      this.collectionId = 0,
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
    int layout = SharedPrefs.loadSavedLayout() ?? 0;
    if (layout == 0)
      return _buildListView(models, _scrollController);
    else
      return _buildGridView(models, _scrollController);
  }

  Widget _buildListView(
      List<PhotoModel> models, ScrollController scrollController) {
    return Container(
        child: ListView.builder(
            key: PageStorageKey("listKey"),
            controller: scrollController,
            itemCount: models.length + 1,
            itemBuilder: (context, int index) {
              if (index == models.length) {
                return SpinKitThreeBounce(
                  color: Colors.purple,
                  size: 30.0,
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    onImagePressed(models[index]);
                  },
                  child:  ImageCard(
                      models[index],
                      () => onFavoritePressed(index),
                    ),

                );
              }
            }));
  }

  Widget _buildGridView(
      List<PhotoModel> models, ScrollController scrollController) {
    return StaggeredGridView.countBuilder(
      key: PageStorageKey("gridKey"),
      controller: scrollController,
      crossAxisCount: 4,
      itemCount: models.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == models.length) {
          return SpinKitThreeBounce(
            color: Colors.purple,
            size: 30.0,
          );
        } else {
          return GestureDetector(
            onTap: () {
              onImagePressed(models[index]);
            },
            child:  GridItemView(
                models[index],
                () => onFavoritePressed(index),
              ),
          );
        }
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(
          index == models.length ? 4 : 2, index == models.length ? .5 : 3.5),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );

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
      if (widget.isFavoriteTab) {
        newModels =
            await _photoRepo.fetchFavoritePhotos(currentPage, widget.userName);
      } else if (widget.isCollectionPhotos) {
        newModels = await _photoRepo.fetchCollectionPhotos(
            currentPage, widget.collectionId);
      } else if (widget.isSearch) {
        newModels = await _photoRepo.searchPhotos(currentPage, widget.query);
      }
      else if (widget.isPhotoUserProfile) {
        newModels = await _photoRepo.fetchUsersPhotos(widget.userName, currentPage);
      }else {
        newModels = await _photoRepo.fetchPhotos(currentPage);
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

  onImagePressed(PhotoModel model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoDetailsScreen(
                model, _photoRepo, widget.sharedPreferences,model.photoId))

    );
  }
}
