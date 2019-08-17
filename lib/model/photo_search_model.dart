import 'package:wallbay/model/photo_response.dart';
import 'package:wallbay/model/photo_search_response.dart';


class PhotoSearchModel {
  String photoId;
  String createdAt;
  int width;
  int height;
  bool liked_by_user;
  String regularPhotoUrl;
  String color;

  //user
  String userId;
  String username;
  String name;
  String mediumProfilePhotoUrl;

  PhotoSearchModel(
      {this.photoId,
      this.createdAt,
      this.width,
      this.height,
      this.liked_by_user,
      this.regularPhotoUrl,
      this.color,
      this.userId,
      this.username,
      this.name,
      this.mediumProfilePhotoUrl});

  PhotoSearchModel.fromPhotoResponse(PhotoResponse response)
      : photoId = response.id,
        createdAt = response.created_at,
        width = response.width,
        height = response.height,
        liked_by_user = response.liked_by_user,
        regularPhotoUrl = response.urls.regular,
        color = response.color,
        userId = response.user.id,
        username = response.user.username,
        name = response.user.name,
        mediumProfilePhotoUrl = response.user.profile_image.medium;
}
