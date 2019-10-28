import 'package:flutter/material.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';

class MainProvider extends ChangeNotifier {
  final _memoizer = AsyncMemoizer<List<PhotoModel>>();
  int _currentPage = 1;

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
  }

  Future<List<PhotoModel>> fetchMoreData() async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }

  //  _morePhotoModelList = await repository.fetchPhotos(_currentPage);

    //todo check if not empty
    // if (_morePhotoModelList.isNotEmpty) {
    //   _photoModelList.addAll(_morePhotoModelList);
    // }

    await Future.delayed(Duration(seconds: 2));

    _isFetchingMore = false;
    notifyListeners();

    return _photoModelList;
  }
}
