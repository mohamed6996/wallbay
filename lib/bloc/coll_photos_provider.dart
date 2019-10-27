import 'package:flutter/material.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';

class CollPhotosProvider extends ChangeNotifier {
  int _currentPage = 1;
  int _collectionId;

  bool _isFetching = false;
  bool _isFetchingMore = false;

  List<PhotoModel> _photoModelList;
  List<PhotoModel> _morePhotoModelList;

  List<PhotoModel> get photoModelList => _photoModelList;
  bool get isFetching => _isFetching;

  int get currentPage => _currentPage;
  void incrementPage() => _currentPage++;

  set photoModelList(List<PhotoModel> list) {
    this._photoModelList = list;
    notifyListeners();
  }

  Future<List<PhotoModel>> fetchData(int collectionId) async {
    this._collectionId = collectionId;
    this._photoModelList =
        await repository.fetchCollectionPhotos(1, _collectionId);
    return _photoModelList;
  }

  Future<List<PhotoModel>> fetchMoreData() async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }

    _morePhotoModelList =
        await repository.fetchCollectionPhotos(_currentPage, _collectionId);
    //todo check if not empty
    if (_morePhotoModelList.isNotEmpty) {
      _photoModelList.addAll(_morePhotoModelList);
    }
    _isFetchingMore = false;
    notifyListeners();

    return _photoModelList;
  }
}
