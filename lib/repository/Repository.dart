import 'dart:async';

import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/model/me_model.dart';
import 'package:wallbay/model/photo_details_model.dart';
import 'package:wallbay/model/photo_model.dart';

abstract class Repository {
  
  Future<List<PhotoModel>> fetchPhotos(int pageNumber);

  Future<List<PhotoModel>> fetchFavoritePhotos(int pageNumber, String userName);

  Future<MeModel> getMe();

  Future<void> likePhoto(String photoId);

  Future<void> unlikePhoto(String photoId);

  Future<List<CollectionModel>> fetchCollections(int pageNumber);

// GET: photos/id
  Future<PhotoDetailsModel> fetchPhotoDetails(String id);

// GET /users/:username/collections
  Future<List<CollectionModel>> fetchUserCollections(
      int pageNumber, String userName);

  //GET /users/:username/photos
  Future<List<PhotoModel>> fetchUserPhotos(int pageNumber, String userName);
}
