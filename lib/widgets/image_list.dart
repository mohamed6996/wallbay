
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/coll_photos_provider.dart';
import 'package:wallbay/bloc/favorite_provider.dart';
import 'package:wallbay/bloc/main_provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';
import 'package:wallbay/bloc/search_provider.dart';
import 'package:wallbay/bloc/user_details_provider.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/screens/photo_details_screen.dart';
import 'package:wallbay/widgets/image_card.dart';

class ImageList extends StatefulWidget {
  final List<PhotoModel> models;
  final isFavoriteTab;
  final bool isCollectionPhotos;
  final bool isSearch;
  final bool isPhotoUserProfile;

  ImageList({
    Key key,
    this.models,
    this.isFavoriteTab = false,
    this.isCollectionPhotos = false,
    this.isSearch = false,
    this.isPhotoUserProfile = false,
  }) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<PhotoModel> models;
  int _oldModelLength = 0;
  int layout;

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  PreferencesProvider preferencesProvider;
  MainProvider mainProvider;
  FavoriteProvider _favoriteProvider;
  CollPhotosProvider _collPhotosProvider;
  SearchProvider _searchProvider;
  UserDetailsProvider _userDetailsProvider;

  @override
  void initState() {
    this.models = widget.models;
    this._oldModelLength = widget.models.length;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context, listen: false);
    _favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    _collPhotosProvider =
        Provider.of<CollPhotosProvider>(context, listen: false);
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    _userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    layout = preferencesProvider.layoutType;
    if (layout == 0)
      return _buildListView();
    else if (layout == 1)
      return _buildGridView();
    else
      return _buildStaggeredGridView();
  }

  Widget _buildListView() {
    return ListView.builder(
        key: PageStorageKey("listKey"),
        controller: _scrollController,
        itemCount: models.length + 1,
        itemBuilder: (context, int index) {
          if (index == models.length) {
            return SpinKitThreeBounce(
              color: Colors.greenAccent,
              size: 30.0,
            );
          } else {
            return GestureDetector(
                onTap: () {
                  onImagePressed(models[index]);
                },
                child: ImageCard(models[index]));
          }
        });
  }

  Widget _buildGridView() {
    return StaggeredGridView.countBuilder(
      key: PageStorageKey("gridKey"),
      controller: _scrollController,
      crossAxisCount: 4,
      itemCount: models.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == models.length) {
          return SpinKitThreeBounce(
            color: Colors.greenAccent,
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

  Widget _buildStaggeredGridView() {
    return StaggeredGridView.countBuilder(
      key: PageStorageKey("staggeredKey"),
      controller: _scrollController,
      crossAxisCount: 4,
      itemCount: models.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == models.length) {
          return SpinKitThreeBounce(
            color: Colors.greenAccent,
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
    if (widget.isFavoriteTab) {
      models = await _favoriteProvider.fetchMoreData();
    } else if (widget.isCollectionPhotos) {
      models = await _collPhotosProvider.fetchMoreData();
    } else if (widget.isSearch) {
      models = await _searchProvider.fetchMoreData();
    } else if (widget.isPhotoUserProfile) {
      models = await _userDetailsProvider.fetchMoreData();
    } else {
      models = await mainProvider.fetchMoreData();
    }

    if (_oldModelLength != models.length) {
      _oldModelLength = models.length;
    } else {
      // check if return data is empty

      double edge = 0;
      switch (layout) {
        case 0:
          edge = 30;
          break;
        case 1:
          edge = 50;
          break;
        default:
          edge = 40;
      }

      double offSetFromBottom = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (offSetFromBottom < edge) {
        _scrollController.animateTo(
            _scrollController.offset - (edge - offSetFromBottom),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    }
  }

  onImagePressed(PhotoModel model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoDetailsScreen(model, model.photoId)));
  }
}
