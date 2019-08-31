import 'package:wallbay/model/photo_response.dart';

class PhotoModel {
  String photoId;
  String createdAt;
  int width;
  int height;
  bool liked_by_user;
  String regularPhotoUrl;
  String color;

  //photo
  String fullPhotoUrl;
  String downloadPhotoUrl;

  //user
  String userId;
  String username;
  String name;
  String mediumProfilePhotoUrl;
  String bio;

  PhotoModel(
      {this.photoId,
      this.createdAt,
      this.width,
      this.height,
      this.liked_by_user,
      this.regularPhotoUrl,
      this.fullPhotoUrl,
      this.downloadPhotoUrl,
      this.color,
      this.userId,
      this.username,
      this.name,
      this.mediumProfilePhotoUrl,
      this.bio});

  PhotoModel.fromPhotoResponse(PhotoResponse response)
      : photoId = response.id,
        createdAt = response.created_at,
        width = response.width,
        height = response.height,
        liked_by_user = response.liked_by_user,
        regularPhotoUrl = response.urls.regular,
        fullPhotoUrl = response.urls.full,
        downloadPhotoUrl = response.links.download,
        color = response.color,
        userId = response.user.id,
        username = response.user.username,
        name = response.user.name,
        mediumProfilePhotoUrl = response.user.profile_image.medium,
        bio = response.user.bio;
}
