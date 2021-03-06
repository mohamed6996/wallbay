import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/model/collectionSearchResponse.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/model/collection_response.dart';
import 'package:wallbay/model/me_model.dart';
import 'package:wallbay/model/me_response.dart';
import 'package:wallbay/model/photo_details_model.dart';
import 'package:wallbay/model/photo_details_response.dart';
import 'package:wallbay/model/photo_search_response.dart';
import 'package:wallbay/repository/Repository.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/model/photo_response.dart';
import 'package:dio/dio.dart';

PhotoRepository repository = PhotoRepository.instance;

class PhotoRepository extends Repository {
  static SharedPreferences _sharedPreferences;
  static Dio _dio;
  static PhotoRepository instance;
  String _clintId = constants.clientId;
  final int _perPage = 20;


  PhotoRepository._();

  static Future<PhotoRepository> create() async {
    PhotoRepository repository = PhotoRepository._();
    _sharedPreferences = await SharedPreferences.getInstance();
    _dio = new Dio();
    instance = repository;
    return repository;
  }

  @override
  Future<List<PhotoModel>> fetchPhotos(int pageNumber) async {
    String photosUrl = "";

    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    PhotoResponseList list;

    if (_sharedPreferences.getBool(Constants.OAUTH_LOGED_IN) ?? false) {
      // https://api.unsplash.com/photos with Authorization: Bearer ACCESS_TOKEN
      photosUrl = Constants.BASE_URL + "photos/?page=$pageNumber&per_page=$_perPage";
      Options options = new Options();
      options.headers = map;
      var response = await _dio.get(photosUrl, options: options);
      list = PhotoResponseList.fromJson(response.data);
    } else {
      photosUrl = Constants.BASE_URL +
          "photos/" +
          "?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";
      var response = await _dio.get(photosUrl);
      list = PhotoResponseList.fromJson(response.data);
    }

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  Future<List<PhotoModel>> fetchUsersPhotos(
      String userName, int pageNumber) async {
    String photosUrl = "";

    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    PhotoResponseList list;

    if (_sharedPreferences.getBool(Constants.OAUTH_LOGED_IN) ?? false) {
      // https://api.unsplash.com/photos with Authorization: Bearer ACCESS_TOKEN
      photosUrl =
          Constants.BASE_URL + "users/$userName/photos/?page=$pageNumber&per_page=$_perPage";
      Options options = new Options();
      options.headers = map;

      var response = await _dio.get(photosUrl, options: options);
      list = PhotoResponseList.fromJson(response.data);
    } else {
      photosUrl = Constants.BASE_URL +
          "users/$userName/photos/" +
          "?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";
      var response = await _dio.get(photosUrl);
      list = PhotoResponseList.fromJson(response.data);
    }

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  Future<List<PhotoModel>> searchPhotos(int pageNumber, String query) async {
    String photosUrl = "";

    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    PhotoSearchResponse list;

    if (_sharedPreferences.getBool(Constants.OAUTH_LOGED_IN) ?? false) {
      photosUrl =
          Constants.BASE_URL + "search/photos/?page=$pageNumber&per_page=$_perPage&query=$query";
      Options options = new Options();
      options.headers = map;

      var response = await _dio.get(photosUrl, options: options);
      list = PhotoSearchResponse.fromJson(response.data);
    } else {
      photosUrl = Constants.BASE_URL +
          "search/photos/" +
          "?client_id=$_clintId&page=$pageNumber&per_page=$_perPage&query=$query";
      var response = await _dio.get(photosUrl);
      list = PhotoSearchResponse.fromJson(response.data);
    }

    List<PhotoModel> models = list.results
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  @override
  Future<List<PhotoModel>> fetchFavoritePhotos(
      int pageNumber, String userName) async {
    String photosUrl = "";

    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    PhotoResponseList list;

    photosUrl = Constants.BASE_URL + "users/$userName/likes/?page=$pageNumber&per_page=$_perPage";
    Options options = new Options();
    options.headers = map;

    var response = await _dio.get(photosUrl, options: options);
    list = PhotoResponseList.fromJson(response.data);

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  reportDownload(String photoId) async {
    String url = Constants.BASE_URL +
        "photos/$photoId/download" +
        "?client_id=$_clintId";
    var response = await _dio.get(url);
  }

  Future<MeModel> getMe() async {
    final meUrl = Constants.BASE_URL + "me";
    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";

    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Options options = new Options();
    options.headers = map;

    var response = await _dio.get(meUrl, options: options);

    var meRes = MeResponse.fromJson(response.data);

    MeModel model = MeModel.fromMeResponse(meRes);

    return model;
  }

  @override
  Future<void> likePhoto(String photoId) async {
    // POST /photos/:id/like   with Authorization: Bearer ACCESS_TOKEN
    final likeUrl = Constants.BASE_URL + "photos/$photoId/like";

    // var prefs = await SharedPreferences.getInstance();
    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";

    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Options options = new Options();
    options.headers = map;

    var response = await _dio.post(likeUrl, options: options);

    return null;
  }

  @override
  Future<void> unlikePhoto(String photoId) async {
    final unlikeUrl = Constants.BASE_URL + "photos/$photoId/like";

    var accessToken =
        _sharedPreferences.getString(Constants.OAUTH_ACCESS_TOKEN) ?? "";
    Map<String, String> map = {"Authorization": "Bearer $accessToken"};

    Options options = new Options();
    options.headers = map;

    var response = await _dio.delete(unlikeUrl, options: options);

    return null;
  }

  @override
  Future<List<CollectionModel>> fetchCollections(int pageNumber) async {
    String collectionsUrl = Constants.BASE_URL +
        "collections/?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";

    var response = await _dio.get(collectionsUrl);
    CollectionResponseList list =
        CollectionResponseList.fromJson(response.data);

    List<CollectionModel> models = list.collectionList
        .map((collectionResponse) =>
            CollectionModel.fromCollectionResponse(collectionResponse))
        .toList();

    return models;
  }

  Future<List<CollectionModel>> searchCollections(int pageNumber,
      {String query = "wallpaper"}) async {
    String collectionsUrl = Constants.BASE_URL +
        "search/collections/?client_id=$_clintId&page=$pageNumber&per_page=$_perPage&query=$query";

    var response = await _dio.get(collectionsUrl);

    CollectionSearchResponse list;

    list = CollectionSearchResponse.fromJson(response.data);

    List<CollectionModel> models = list.results
        .map((collectionResponse) =>
            CollectionModel.fromCollectionResponse(collectionResponse))
        .toList();

    return models;
  }

  Future<List<PhotoModel>> fetchCollectionPhotos(
      int pageNumber, int collectionId) async {
    PhotoResponseList list;

    String collectionsUrl = Constants.BASE_URL +
        "collections/$collectionId/photos/?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";

    var response = await _dio.get(collectionsUrl);
    list = PhotoResponseList.fromJson(response.data);

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  @override
  Future<List<CollectionModel>> fetchUserCollections(
      int pageNumber, String userName) async {
    String collectionsUrl = Constants.BASE_URL +
        "users/$userName/collections/?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";

    var response = await _dio.get(collectionsUrl);
    CollectionResponseList list =
        CollectionResponseList.fromJson(response.data);

    List<CollectionModel> models = list.collectionList
        .map((collectionResponse) =>
            CollectionModel.fromCollectionResponse(collectionResponse))
        .toList();

    return models;
  }

  @override
  Future<List<PhotoModel>> fetchUserPhotos(
      int pageNumber, String userName) async {
    String userPhotosUrl = Constants.BASE_URL +
        "users/$userName/photos/?client_id=$_clintId&page=$pageNumber&per_page=$_perPage";

    var response = await _dio.get(userPhotosUrl);

    var list = PhotoResponseList.fromJson(response.data);

    List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

    return models;
  }

  @override
  Future<PhotoDetailsModel> fetchPhotoDetails(String id) async {
    String userPhotosUrl =
        Constants.BASE_URL + "photos/$id/?client_id=$_clintId";

    var response = await _dio.get(userPhotosUrl);

    var res = PhotoDetails.fromJson(response.data);

    return PhotoDetailsModel.fromPhotoResponse(res);
  }
}
