import 'package:flutter/material.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';

class CollectionProvider extends ChangeNotifier {
  final _allMemoizer = AsyncMemoizer<List<CollectionModel>>();
  final _wallpaperMemoizer = AsyncMemoizer<List<CollectionModel>>();

  int _currentPage = 1;
  bool _isFetchingMore = false;

  List<CollectionModel> _photoModelList = [];
  List<CollectionModel> _wallModelList = [];

  List<CollectionModel> _morePhotoModelList;
  List<CollectionModel> _moreWall;

  List<CollectionModel> get photoModelList => _photoModelList;

  int get currentPage => _currentPage;
  void incrementPage() => _currentPage++;

  set photoModelList(List<CollectionModel> list) {
    this._photoModelList = list;
    notifyListeners();
  }

  Future<List<CollectionModel>> fetchData() async {
    return _allMemoizer.runOnce(() async {
      _photoModelList = await repository.fetchCollections(1);
      return _photoModelList;
    });
  }

  Future<List<CollectionModel>> fetchWallPaper() {
    return _wallpaperMemoizer.runOnce(() async {
      _wallModelList = await repository.searchCollections(1);
      return _wallModelList;
    });
  }

  Future<List<CollectionModel>> fetchMoreData(int collectionType) async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }

    if (collectionType == 0) {
      _morePhotoModelList = await repository.fetchCollections(_currentPage);
      _photoModelList.addAll(_morePhotoModelList);
    } else {
      _moreWall = await repository.searchCollections(_currentPage);
      _wallModelList.addAll(_moreWall);
    }

    _isFetchingMore = false;
    notifyListeners();

    return collectionType == 0 ? _photoModelList : _wallModelList;
  }
}
