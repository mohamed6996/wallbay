import 'dart:convert';

import 'package:wallbay/repository/Repository.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/model/photo_response.dart';
import 'package:http/http.dart' show get;

class PhotoRepository extends Repository {
//  final uri = Uri.https(
//      Constants.BASE_URL, "photos/", {"client_id": Constants.clientId});



  @override
  Future<List<PhotoModel>> fetchPhotos(int pageNumber) async {
    final url = Constants.BASE_URL + "photos/" + "?client_id=${Constants.clientId}&page=$pageNumber";

    var res = await get(url);
    PhotoResponseList list = PhotoResponseList.fromJson(jsonDecode(res.body));

     List<PhotoModel> models = list.responseList
        .map((photoResponse) => PhotoModel.fromPhotoResponse(photoResponse))
        .toList();

     print("width: ${models[0].width}");
    print("height: ${models[0].height}");


    return models;

  }
}
