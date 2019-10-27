import 'package:flutter/material.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';
import 'package:async/async.dart';

class FavoriteProvider extends ChangeNotifier {
  String _userName;

  final _memoizer = AsyncMemoizer<List<PhotoModel>>();
  int _currentPage = 1;

  bool _isFetching = false;
  bool _isFetchingMore = false;

  List<PhotoModel> _photoModelList=[];
  List<PhotoModel> _morePhotoModelList=[];

  List<PhotoModel> get photoModelList => _photoModelList;
  bool get isFetching => _isFetching;

  int get currentPage => _currentPage;
  void incrementPage() => _currentPage++;

  set photoModelList(List<PhotoModel> list) {
    this._photoModelList = list;
    notifyListeners();
  }

  addFavorite(PhotoModel photoModel) {
    this._photoModelList.insert(0, photoModel);
    notifyListeners();
  }

  removeFavorite(PhotoModel photoModel) {
    this._photoModelList.remove(photoModel);
    notifyListeners();
  }

  Future<List<PhotoModel>> fetchData(String userName) async {
    this._userName = userName;
    return _memoizer.runOnce(() async {
      this._photoModelList = await repository.fetchFavoritePhotos(1, _userName);
      return _photoModelList;
    });
  }

  Future<List<PhotoModel>> fetchMoreData() async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }
    _morePhotoModelList =
        await repository.fetchFavoritePhotos(_currentPage, _userName);
    //todo check if not empty
    if (_morePhotoModelList.isNotEmpty) {
      _photoModelList.addAll(_morePhotoModelList);
    }
    _isFetchingMore = false;
    notifyListeners();

    return _photoModelList;
  }
}
