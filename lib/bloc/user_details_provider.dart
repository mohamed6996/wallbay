import 'package:flutter/material.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/repository/photo_repository.dart';

class UserDetailsProvider extends ChangeNotifier {
  int _currentPage = 1;

  bool _isFetching = false;
  bool _isFetchingMore = false;
  String _userName;

  List<PhotoModel> _photoModelList =[];
  List<PhotoModel> _morePhotoModelList;

  List<PhotoModel> get photoModelList => _photoModelList;
  bool get isFetching => _isFetching;

  int get currentPage => _currentPage;
  void incrementPage() => _currentPage++;

  set photoModelList(List<PhotoModel> list) {
    this._photoModelList = list;
    notifyListeners();
  }

  Future<List<PhotoModel>> fetchData(String userName) async {
    this._userName = userName;
    this._photoModelList = await repository.fetchUsersPhotos(_userName,1);
    return _photoModelList;
  }

  Future<List<PhotoModel>> fetchMoreData() async {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      incrementPage();
    }

    _morePhotoModelList = await repository.fetchUsersPhotos(_userName,_currentPage);
    //todo check if not empty
    if (_morePhotoModelList.isNotEmpty) {
      _photoModelList.addAll(_morePhotoModelList);
    }
    _isFetchingMore = false;
    notifyListeners();

    return _photoModelList;
  }
}
