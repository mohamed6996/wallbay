import 'package:wallbay/model/photo_response.dart';

class PhotoModel {
  String photoId;
  String createdAt;
  int width;
  int height;
  bool liked_by_user;
  String raw;
  String full;
  String regular;
  String small;
  String color;

  //photo //don`t use for downloading
  String fullPhotoUrl;
  String downloadPhotoUrlRaw;
  String downloadPhotoUrlFull;
  String downloadPhotoUrlRegular;
  String downloadPhotoUrlSmall;

  //user
  String userId;
  String username;
  String name;
  String largeProfilePhotoUrl;
  String bio;

  PhotoModel(
      {this.photoId,
      this.createdAt,
      this.width,
      this.height,
      this.liked_by_user,
      this.raw,
      this.full,
      this.regular,
      this.small,
      this.fullPhotoUrl,
      this.downloadPhotoUrlRaw,
      this.downloadPhotoUrlFull,
      this.downloadPhotoUrlRegular,
      this.downloadPhotoUrlSmall,
      this.color,
      this.userId,
      this.username,
      this.name,
      this.largeProfilePhotoUrl,
      this.bio});

  PhotoModel.fromPhotoResponse(PhotoResponse response)
      : photoId = response.id,
        createdAt = response.created_at,
        width = response.width,
        height = response.height,
        liked_by_user = response.liked_by_user,
        raw = response.urls.raw,
        full = response.urls.full,
        regular = response.urls.regular,
        small = response.urls.small,
        fullPhotoUrl = response.urls.full,
        downloadPhotoUrlRaw = response.links.download,
        color = response.color,
        userId = response.user.id,
        username = response.user.username,
        name = response.user.name,
        largeProfilePhotoUrl = response.user.profile_image.large,
        bio = response.user.bio;
}
