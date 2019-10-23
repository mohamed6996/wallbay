import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:wallbay/screens/photo_details_screen.dart';
import 'package:wallbay/utils/shared_prefs.dart';
import 'package:wallbay/widgets/image_card.dart';

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;
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

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final PreferencesProvider mainProvider = Provider.of<PreferencesProvider>(context);
    int layout = mainProvider.layoutType;

    if (layout == 0)
      return _buildListView(models, _scrollController);
    else if (layout == 1)
      return _buildGridView(models, _scrollController);
    else
      return _buildStaggeredGridView(models, _scrollController);
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
                    child: ImageCard(models[index]));
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
            child: GridItemView(models[index]),
          );
        }
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(
          index == models.length ? 4 : 2, index == models.length ? .5 : 3.5),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _buildStaggeredGridView(
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
            child: StaggeredWidget(
              models[index],
            ),
          );
        }
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      padding: EdgeInsets.all(4),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
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
      } else if (widget.isPhotoUserProfile) {
        newModels =
            await _photoRepo.fetchUsersPhotos(widget.userName, currentPage);
      } else {
        newModels = await _photoRepo.fetchPhotos(currentPage);
      }
      // check if return data is empty
      if (newModels.isEmpty) {
        double edge = 40;
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
                model, model.photoId)));
  }
}
