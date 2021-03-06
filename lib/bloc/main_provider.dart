import 'package:flutter/material.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';
import 'package:wallbay/utils/connectivity_checker.dart';

class MainProvider extends ChangeNotifier {
  final _memoizer = AsyncMemoizer<List<PhotoModel>>();
  int _currentPage = 1;

  bool _isFetching = false;
  bool _isFetchingMore = false;

  List<PhotoModel> _photoModelList = [];
  List<PhotoModel> _morePhotoModelList = [];

  List<PhotoModel> get photoModelList => _photoModelList;
  bool get isFetching => _isFetching;

  int get currentPage => _currentPage;
  void incrementPage() => _currentPage++;

  set photoModelList(List<PhotoModel> list) {
    this._photoModelList = list;
    notifyListeners();
  }

  removeFavorite(PhotoModel photoModel) {
    int index = _photoModelList
        .indexWhere((model) => model.photoId == photoModel.photoId);
    if (index != -1) {
      _photoModelList.elementAt(index).liked_by_user = false;
      notifyListeners();
    }
  }

  Future<List<PhotoModel>> fetchData() async {

      return _memoizer.runOnce(() async {
        this._photoModelList = await repository.fetchPhotos(1);
        return _photoModelList;
      });


    // bool status = await checkConnectivity();
    // if (status) {
    //   return _memoizer.runOnce(() async {
    //     this._photoModelList = await repository.fetchPhotos(1);
    //     return _photoModelList;
    //   });
    // }
    // return _photoModelList;
  }

  Future refreshData() async {
    // bool status = await checkConnectivity();
    // if (!status) return;
    var newList = await repository.fetchPhotos(1);
    if (newList != null && newList.length > 0) {
      this._photoModelList.clear();
      this._photoModelList.addAll(newList);
      notifyListeners();
    }
  }

  Future<List<PhotoModel>> fetchMoreData() async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }

    _morePhotoModelList = await repository.fetchPhotos(_currentPage);
    if (_morePhotoModelList.isNotEmpty) {
      _photoModelList.addAll(_morePhotoModelList);
    }

    _isFetchingMore = false;
    notifyListeners();

    return _photoModelList;
  }
}
