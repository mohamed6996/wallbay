import 'dart:async';

import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/model/me_model.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/model/photo_response.dart';

abstract class Repository {
  // https://api.unsplash.com/
  // Authorization: Bearer ACCESS_TOKEN
  // GET /photos

  //*
  // Parameters
  //
  //page 	    Page number to retrieve. (Optional; default: 1)
  //per_page 	Number of items per page. (Optional; default: 10)
  //order_by 	How to sort the photos. Optional. (Valid values: latest, oldest, popular; default: latest)
  //
  // */

  //*
  // if user is logged in then  https://api.unsplash.com/photos with Authorization: Bearer ACCESS_TOKEN
  //
  // else  https://api.unsplash.com/photos/https://api.unsplash.com/photos/?client_id=YOUR_ACCESS_KEY
  //
  //
  //
  // */
  Future<List<PhotoModel>> fetchPhotos(int pageNumber);

  Future<List<PhotoModel>> fetchFavoritePhotos(int pageNumber,String userName);

  Future<MeModel> getMe();

  Future<void> likePhoto(String photoId);

  Future<void> unlikePhoto(String photoId);

  Future<List<CollectionModel>> fetchCollections(int pageNumber);


}
