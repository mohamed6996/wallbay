import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/repository/Repository.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/model/photo_response.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PhotoRepository extends Repository {
  final SharedPreferences _sharedPreferences;

  PhotoRepository(this._sharedPreferences);

  @override
  Future<List<PhotoModel>> fetchPhotos(int pageNumber) async {
    String photosUrl = "";

    var accessToken = _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Dio dio = new Dio();
    PhotoResponseList list;

    if (_sharedPreferences.getBool(Constants.OAUTH_LOGED_IN)?? false) {
      // https://api.unsplash.com/photos with Authorization: Bearer ACCESS_TOKEN
      photosUrl = Constants.BASE_URL + "photos";
      Options options = new Options();
      options.headers = map;

      var response = await dio.get(photosUrl, options: options);
      list = PhotoResponseList.fromJson(response.data);
    } else {
      photosUrl = Constants.BASE_URL +
          "photos/" +
          "?client_id=${Constants.clientId}&page=$pageNumber";
      var response = await dio.get(photosUrl);
      list = PhotoResponseList.fromJson(response.data);
    }

//    final url = Constants.BASE_URL +
//        "photos/" +
//        "?client_id=${Constants.clientId}&page=$pageNumber";
//
//    var res = await http.get(url);
//    print(res.body);
//    PhotoResponseList list = PhotoResponseList.fromJson(jsonDecode(res.body));

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  @override
  Future<void> likePhoto(String photoId) async {
    // POST /photos/:id/like   with Authorization: Bearer ACCESS_TOKEN
    final likeUrl = Constants.BASE_URL + "photos/$photoId/like";

    // var prefs = await SharedPreferences.getInstance();
    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ??"";

    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Dio dio = new Dio();
    Options options = new Options();
    options.headers = map;

    var response = await dio.post(likeUrl, options: options);


    return null;
  }

  @override
  Future<void> unlikePhoto(String photoId) async {
    final unlikeUrl = Constants.BASE_URL + "photos/$photoId/like";

    var accessToken = _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Dio dio = new Dio();
    Options options = new Options();
    options.headers = map;

    var response = await dio.delete(unlikeUrl, options: options);

    return null;
  }
}
