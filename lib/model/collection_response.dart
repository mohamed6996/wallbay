import 'package:json_annotation/json_annotation.dart';
import 'package:wallbay/model/photo_response.dart';

part 'collection_response.g.dart';

class CollectionResponseList{

  List<CollectionResponse> collectionList;

  CollectionResponseList({this.collectionList});

  factory CollectionResponseList.fromJson(List<dynamic> json) {
    List<CollectionResponse> responses = new List<CollectionResponse>();
    responses = json.map((i) => CollectionResponse.fromJson(i)).toList();
    return new CollectionResponseList(collectionList: responses);
  }

}

@JsonSerializable()
class CollectionResponse{
// alt, shift, insert

   int id;
   String title;
   String description;
   String published_at;
   bool curated;
   int total_photos;
   bool private;
   String share_key;
   CoverPhoto cover_photo;
   User user;

   CollectionResponse(this.id, this.title, this.description, this.published_at,
       this.curated, this.total_photos, this.private, this.share_key,
       this.cover_photo, this.user);

   factory CollectionResponse.fromJson(Map<String, dynamic> json) =>
       _$CollectionResponseFromJson(json);
}

@JsonSerializable()
class CoverPhoto{
  String id;
  double width;
  double height;
  String color;
  int likes;
  bool liked_by_user;
  String description;
  CoverPhotoUrl urls;
  User user;

  CoverPhoto(this.id, this.width, this.height, this.color, this.likes,
      this.liked_by_user, this.description, this.urls,this.user);

  factory CoverPhoto.fromJson(Map<String, dynamic> json) =>
      _$CoverPhotoFromJson(json);

}

@JsonSerializable()
class CoverPhotoUrl{
  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  CoverPhotoUrl(this.raw, this.full, this.regular, this.small, this.thumb);

  factory CoverPhotoUrl.fromJson(Map<String, dynamic> json) =>
      _$CoverPhotoUrlFromJson(json);
}





