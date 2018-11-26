import 'package:wallbay/model/collection_response.dart';

class CollectionModel {
  int id;
  String title;
  String description;
  int totalPhotos;

  //cover photo
  String coverPhotoId;
  String coverPhotoColor;
  int coverPhotoLikes;
  bool coverPhotoLikedByUser;
  String coverPhotoDescription;
  String coverPhotoUrl;

  CollectionModel(
      this.id,
      this.title,
      this.description,
      this.totalPhotos,
      this.coverPhotoId,
      this.coverPhotoColor,
      this.coverPhotoLikes,
      this.coverPhotoLikedByUser,
      this.coverPhotoDescription,
      this.coverPhotoUrl);

  CollectionModel.fromCollectionResponse(CollectionResponse res)
      : id = res.id,
        title = res.title,
        description = res.description,
        totalPhotos = res.total_photos,
        coverPhotoId = res.cover_photo.id,
        coverPhotoColor = res.cover_photo.color,
        coverPhotoLikes = res.cover_photo.likes,
        coverPhotoLikedByUser = res.cover_photo.liked_by_user,
        coverPhotoDescription = res.cover_photo.description,
        coverPhotoUrl = res.cover_photo.urls.small;
}
